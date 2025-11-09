import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/market.dart';
import 'package:hafar_market_app/models/selection_map.dart';
import 'package:hafar_market_app/ui/screens/new_offer.dart/offer_details.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';

class OfferCategory extends StatefulWidget {
  final MarketModel? market;
  final CategoryModel? category;
  final String marketLabel;
  final List<String>? parentCategories;

  const OfferCategory({
    super.key,
    this.market,
    this.category,
    required this.marketLabel,
    this.parentCategories,
  });

  @override
  State<OfferCategory> createState() => _OfferCategoryState();
}

late SelectionMap selectionMap;

class _OfferCategoryState extends State<OfferCategory> {
  String? _selectedSubCategory;
  late List<String> _categoryPath;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _categoryPath = widget.parentCategories ?? [];
    selectionMap = SelectionMap(market: widget.marketLabel);
    if (widget.category != null && _categoryPath.isEmpty) {
      _categoryPath.add(widget.category!.name);
    }
  }

  Widget buildChoiceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }

  void navigateToDetails() {
    if (!_navigated) {
      _navigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectionMap.category =
            _categoryPath.isNotEmpty
                ? _categoryPath.first
                : widget.category?.name;
        selectionMap.subCategories =
            _categoryPath.length > 1 ? _categoryPath.sublist(1) : [];

        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => OfferDetails(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = "";
    List<Widget> categoryChips = [];

    if (widget.market != null) {
      title = "اختر فئة ${widget.market!.label}";
      categoryChips =
          widget.market!.categories.map((category) {
            return buildChoiceChip(
              label: category.name,
              selected: _categoryPath.contains(category.name),
              onTap: () {
                final newPath = [category.name];
                final hasSub =
                    category.subItems?.isNotEmpty == true ||
                    category.children?.isNotEmpty == true;
                if (hasSub) {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder:
                          (context) => OfferCategory(
                            category: category,
                            marketLabel: widget.marketLabel,
                            parentCategories: newPath,
                          ),
                    ),
                  );
                } else {
                  selectionMap.category = newPath.first;
                  selectionMap.subCategories = newPath.sublist(1);
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder:
                          (context) =>
                              OfferDetails(),
                    ),
                  );
                }
              },
            );
          }).toList();
    } else if (widget.category != null) {
      title = "اختر تصنيف ${widget.category!.name} (${widget.marketLabel})";
      if (widget.category!.subItems?.isNotEmpty == true) {
        categoryChips =
            widget.category!.subItems!.map((subCategory) {
              return buildChoiceChip(
                label: subCategory,
                selected: _categoryPath.contains(subCategory),
                onTap: () {
                  final newPath = List<String>.from(_categoryPath)
                    ..add(subCategory);
                  selectionMap.category = newPath.first;
                  selectionMap.subCategories = newPath.sublist(1);
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder:
                          (context) =>
                              OfferDetails(),
                    ),
                  );
                },
              );
            }).toList();
      } else if (widget.category!.children?.isNotEmpty == true) {
        categoryChips =
            widget.category!.children!.map((childCategory) {
              final hasSub =
                  childCategory.subItems?.isNotEmpty == true ||
                  childCategory.children?.isNotEmpty == true;
              return buildChoiceChip(
                label: childCategory.name,
                selected: _categoryPath.contains(childCategory.name),
                onTap: () {
                  final newPath = List<String>.from(_categoryPath)
                    ..add(childCategory.name);
                  if (hasSub) {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder:
                            (context) => OfferCategory(
                              category: childCategory,
                              marketLabel: widget.marketLabel,
                              parentCategories: newPath,
                            ),
                      ),
                    );
                  } else {
                    selectionMap.category = newPath.first;
                    selectionMap.subCategories = newPath.sublist(1);
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder:
                            (context) =>
                                OfferDetails(),
                      ),
                    );
                  }
                },
              );
            }).toList();
      } else {
        navigateToDetails();
      }
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: Dimensions.bodyPadding,
        child: ListView(
          children: [Wrap(spacing: 10, runSpacing: 5, children: categoryChips)],
        ),
      ),
    );
  }
}
