import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/user/user_controller.dart';
import 'package:hafar_market_app/controllers/offer_controller.dart';
import 'package:hafar_market_app/models/offer_model.dart';
import 'package:hafar_market_app/models/user/user.dart';
import 'package:hafar_market_app/providers/user_provider.dart';
import 'package:hafar_market_app/ui/screens/offer_comments.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/account_tile.dart';
import 'package:hafar_market_app/ui/widget/card.dart';
import 'package:hafar_market_app/ui/widget/comment.dart';
import 'package:hafar_market_app/ui/widget/offer_picture.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:hafar_market_app/utils/format_timestamp.dart';
import 'package:provider/provider.dart';
import 'package:uicons/uicons.dart';
// import 'package:hafar_market_app/l10n/app_localizations.dart';

class OfferPage extends StatefulWidget {
  final OfferModel offer;
  const OfferPage({super.key, required this.offer});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  UserController userController = UserController();
  final OfferController _offerController = OfferController();

  UserDTO? userDTO;
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    userController.getUser(widget.offer.userId, context).then((user) {
      if (mounted) {
        setState(() {
          userDTO = user;
        });
      }
    });
    if (widget.offer.id.isNotEmpty) {
      _offerController.incrementOfferViews(widget.offer.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final UserDTO? currentUser = userProvider.currentUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async {
                            // if (widget.offer.id.isNotEmpty) {
                            //   _offerController.incrementOfferShares(widget.offer.id);
                            //   final uri = await DynamicLinksService(navigatorKey: rootNavigatorKey)
                            //       .buildOfferLink(widget.offer.id);
                            //   Share.share(uri.toString());
                            // }
                          },
                          icon: Icon(UIcons.regularRounded.redo),
                        ),
          IconButton(onPressed: () {}, icon: Icon(UIcons.regularRounded.heart)),
          IconButton(onPressed: () {}, icon: Icon(UIcons.regularRounded.flag)),
          gap(width: 8),
        ],
      ),
      body: ListView(
        children: [
          widget.offer.pictures.isNotEmpty
              ? Column(
                children: [
                  gap(height: 16),
                  CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: 280,
                      viewportFraction: 0.9,
                      enableInfiniteScroll: false,
                      autoPlay: widget.offer.pictures.length > 1,
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
                    items: widget.offer.pictures.map((pictureUrl) {
                      return OfferPicture(
                        pictureUrl: pictureUrl,
                      );
                    }).toList(),
                  ),
                  DotsIndicator(
                    dotsCount: widget.offer.pictures.length,
                    position: _currentImageIndex.toDouble(),
                    decorator: DotsDecorator(
                      color: Theme.of(context).dividerTheme.color!,
                      activeColor: AppColors.primaryColor,
                    ),
                  ),
                ],
              )
              : SizedBox(),
          gap(height: 16),
          Padding(
            padding: Dimensions.bodyPadding,
            child: UICard(
              child: Padding(
                padding: Dimensions.bodyPadding.copyWith(top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTimestamp(widget.offer.createdAt)),
                        widget.offer.area != null
                            ? Text(widget.offer.area!)
                            : SizedBox(),
                      ],
                    ),
                    gap(height: 10),
                    Text(
                      widget.offer.content,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    gap(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.offer.price.toString(),
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(color: AppColors.primaryColor),
                        ),
                        gap(width: 5),
                        Image.asset(
                          "assets/images/riyal.png",
                          width: 16,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    gap(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (currentUser != null &&
                            widget.offer.userId == currentUser.userId)
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {},
                                label: Text("تعديل"),
                                icon: Icon(UIcons.regularRounded.pencil),
                              ),
                            ],
                          ),
                        widget.offer.enhanced != true
                            ? Row(
                              children: [
                                gap(width: 10),
                                FilledButton.icon(
                                  onPressed: null,
                                  label: Text("تعزيز"),
                                  icon: Icon(UIcons.solidRounded.crown),
                                ),
                              ],
                            )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          gap(height: 16),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "التصنيف والوسوم",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            subtitle: Wrap(
              spacing: 10,
              runSpacing: 0,
              children:
                  widget.offer.tags.map((tag) {
                    return Chip(label: Text(tag));
                  }).toList(),
            ),
          ),

          gap(height: 16),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "المُعلن",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            subtitle: AccountTile(actionButton: SizedBox(), user: userDTO),
          ),
          gap(height: 16),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "التعليقات",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            subtitle: Comment(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => OfferComments(user: currentUser,)),
                  );
                },
                child: Text("عرض المزيد"),
              ),
            ],
          ),
          gap(height: 16),
        ],
      ),
    );
  }
}
