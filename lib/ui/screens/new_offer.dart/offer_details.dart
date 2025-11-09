import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafar_market_app/models/areas.dart';
import 'package:hafar_market_app/models/market.dart';
import 'package:hafar_market_app/ui/screens/new_offer.dart/offer_category.dart';
import 'package:hafar_market_app/ui/screens/new_offer.dart/offer_pictures.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/drop_down.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:uicons/uicons.dart';

class OfferDetails extends StatefulWidget {
  const OfferDetails({super.key});

  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}

TextEditingController contentController = TextEditingController();
TextEditingController priceController = TextEditingController();

final List<String> tags = [];
List<String> generatedTags = [];

String? selectedArea;

class _OfferDetailsState extends State<OfferDetails> {
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (selectionMap.category != null && selectionMap.category!.isNotEmpty) {
      tags.add(selectionMap.category!);
    }
    if (selectionMap.subCategories != null) {
      try {
        tags.addAll(selectionMap.subCategories!);
      } catch (e) {
        debugPrint("Error adding subcategories: $e");
      }
    }
  }

  void _addTag() {
    if (_tagController.text.trim().isNotEmpty &&
        !tags.contains(_tagController.text)) {
      setState(() {
        tags.add(_tagController.text.trim());
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("تفاصيل العرض"),
            selectionMap.market != null
                ? TextButton.icon(
                  onPressed: () {},
                  icon: Icon(getMarketIconForLabel(selectionMap.market!)),
                  label: Text(selectionMap.market!),
                )
                : SizedBox(),
          ],
        ),
      ),
      body: Padding(
        padding: Dimensions.bodyPadding,
        child: ListView(
          children: [
            gap(height: 16),
            TextFormField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "نص العرض",
                alignLabelWithHint: true,
              ),
              onChanged: (value) {
                setState(() {
                  // 1. Remove numbers, brackets, and most punctuation.
                  //    \u0600-\u06FF covers the Arabic Unicode range.
                  //    [^...] means "any character NOT in this set".
                  //    Replace any non-Arabic letter or non-space character with a single space.
                  final cleanedValue = value.replaceAll(
                    RegExp(r'[^ \u0600-\u06FF]+'),
                    ' ',
                  );

                  // 2. Split by one or more whitespace characters
                  // 3. Trim each resulting word
                  // 4. Filter out any empty strings that might result from multiple spaces
                  // 5. Convert to a Set to get unique tags
                  // 6. Convert back to a List
                  generatedTags =
                      cleanedValue
                          .split(RegExp(r'\s+')) // Split by one or more spaces
                          .map((tag) => tag.trim())
                          .where((tag) => tag.isNotEmpty)
                          .toSet() // Remove duplicates
                          .toList();
                });
              },
            ),
            gap(height: 16),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: "السعر(اختياري)"),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              keyboardType: TextInputType.number,
            ),
            gap(height: 10),
            DropDown(
              label: "الحي",
              items: areasList,
              onChanged: (newValue) {
                setState(() {
                  selectedArea = newValue;
                });
              },
            ),
            gap(height: 16),
            // Tags Input Field
            Wrap(
              spacing: 10,
              runSpacing: 0,
              children:
                  (tags + generatedTags).map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () => _removeTag(tag),
                      deleteIcon: Icon(UIcons.regularRounded.cross_small),
                    );
                  }).toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      labelText: "إضافة كلمات مفتاحية",
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                gap(width: 10),
                IconButton.filled(
                  onPressed: _addTag,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            gap(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          border: Border(
            top: BorderSide(
              color:
                  Theme.of(
                    context,
                  ).inputDecorationTheme.enabledBorder!.borderSide.color,
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
                onPressed:
                    contentController.text.trim().isNotEmpty &&
                            selectedArea != null
                        ? () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => OfferPictures(),
                            ),
                          );
                        }
                        : null,
                child: Text("التالي"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
