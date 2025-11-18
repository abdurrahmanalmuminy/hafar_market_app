import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hafar_market_app/controllers/error_handler.dart';
import 'package:hafar_market_app/models/user/user.dart';
import 'package:hafar_market_app/providers/user_provider.dart';
import 'package:hafar_market_app/services/storage_service.dart';
import 'package:hafar_market_app/ui/screens/new_offer.dart/view_offer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uicons/uicons.dart';

class OfferPictures extends StatefulWidget {
  const OfferPictures({super.key});

  @override
  State<OfferPictures> createState() => _OfferPicturesState();
}

class _OfferPicturesState extends State<OfferPictures> {
  final ErrorHandler _errorHandler = ErrorHandler();
  final StorageService _storage = StorageService();

  final List<PlatformFile> _localImages = [];
  final List<String> _uploadedUrls = [];
  bool _uploading = false;
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  Future<void> _pickImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result == null) return;
      final files = result.files.toList();
      final allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};
      int skipped = 0;
      final validFiles = <PlatformFile>[];
      for (final f in files) {
        if (f.path == null) {
          skipped++;
          continue;
        }
        final ext = (f.extension ?? '').toLowerCase();
        final isAllowed = allowedExtensions.contains(ext);
        if (isAllowed) {
          validFiles.add(f);
        } else {
          skipped++;
        }
      }
      if (validFiles.isEmpty && skipped > 0) {
        if (mounted) _errorHandler.showSnackBar(context, 'بعض الصور غير مدعومة (مثل HEIC) أو تالفة');
        return;
      }
      if (mounted) {
        setState(() {
          final remaining = 10 - _localImages.length;
          final toAdd = validFiles.take(remaining).toList();
          _localImages.addAll(toAdd);
        });
        if (skipped > 0) {
          _errorHandler.showSnackBar(context, 'تم تجاهل $skipped ملف/ملفات غير مدعومة');
        }
      }
    } catch (e, s) {
      _errorHandler.recordError(e, s);
      if (mounted) _errorHandler.showSnackBar(context, 'تعذر اختيار الصور');
    }
  }

  Future<void> _uploadAndContinue() async {
    if (_uploading) return;
    if (_localImages.isEmpty) {
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const ViewOffer(pictureUrls: [])));
      return;
    }

    final UserDTO? currentUser = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (currentUser == null) {
      _errorHandler.showSnackBar(context, 'الرجاء تسجيل الدخول أولاً');
      return;
    }

    setState(() => _uploading = true);
    _uploadedUrls.clear();
    try {
      // Force refresh auth token to avoid precondition issues due to stale tokens
      try {
        await FirebaseAuth.instance.currentUser?.getIdToken(true);
      } catch (e, s) {
        _errorHandler.recordError(e, s);
      }
      int failed = 0;
      for (final pickedImage in _localImages) {
        try {
          final url = await _storage.uploadOfferImage(
            userId: currentUser.userId,
            pickedImage: pickedImage,
          );
          _uploadedUrls.add(url);
        } catch (e, s) {
          failed++;
          _errorHandler.recordError(e, s);
        }
      }
      if (!mounted) return;
      if (_uploadedUrls.isEmpty) {
        _errorHandler.showSnackBar(context, 'فشل رفع جميع الصور، حاول صوراً أخرى');
        return;
      }
      if (failed > 0) {
        _errorHandler.showSnackBar(context, 'تم رفع بعض الصور فقط، فشل $failed صورة');
      }
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => ViewOffer(pictureUrls: _uploadedUrls),
        ),
      );
    } catch (e, s) {
      _errorHandler.recordError(e, s);
      if (mounted) _errorHandler.showSnackBar(context, 'فشل رفع الصور، حاول مرة أخرى');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("حمل الصور")),
      body: ListView(
        children: [
          gap(height: 16),
          _localImages.isNotEmpty
              ? Column(
                children: [
                  CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: 280,
                      viewportFraction: 0.9,
                      enableInfiniteScroll: false,
                      autoPlay: _localImages.length > 1,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayCurve: Curves.easeInOutCubic,
                      onPageChanged: (index, reason) {
                        if (mounted) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        }
                      },
                    ),
                    items: _localImages.map((pickedImage) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color:
                                  Theme.of(
                                    context,
                                  ).inputDecorationTheme.enabledBorder!.borderSide.color,
                            ),
                          ),
                          child: pickedImage.path != null 
                              ? Image.file(File(pickedImage.path!), fit: BoxFit.cover)
                              : const SizedBox(),
                        ),
                      );
                    }).toList(),
                  ),
                  DotsIndicator(
                    dotsCount: _localImages.length,
                    position: _currentImageIndex.toDouble(),
                    decorator: DotsDecorator(
                      color: Theme.of(context).dividerTheme.color!,
                      activeColor: AppColors.primaryColor,
                    ),
                  ),
                ],
              )
              : SizedBox(),
          gap(height: 10),
          Padding(
        padding: Dimensions.bodyPadding,
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _pickImages,
                  label: const Text("أضف صورة"),
                  icon: Icon(UIcons.regularRounded.plus),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          border: Border(
            top: BorderSide(
              color: Theme.of(context)
                  .inputDecorationTheme
                  .enabledBorder!
                  .borderSide
                  .color,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: Dimensions.bodyPadding.copyWith(top: 10),
            child: SizedBox(
              height: 55,
              width: double.infinity,
              child: FilledButton(
                onPressed: _uploading ? null : _uploadAndContinue,
                child: _uploading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("التالي"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
