import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/offer_controller.dart';
import 'package:hafar_market_app/models/market.dart';
import 'package:hafar_market_app/models/offer_model.dart';
import 'package:hafar_market_app/ui/bottom_sheets/area_selection.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/offer.dart';
import 'package:hafar_market_app/ui/widget/shimmer_container.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:uicons/uicons.dart';

class MarketPage extends StatefulWidget {
  final MarketModel market;
  const MarketPage({super.key, required this.market});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final OfferController _offersController = OfferController();

  late Future<List<MarketModel>> futureMarkets;

  String? _selectedSubCategory;
  String? _selectedSubSubCategory;
  CategoryModel? _selectedCategoryModel;
  int _selectedTabIndex = 0;
  late CategoryModel _currentCategory; //keep track of current category

  List<String> areas = [];

  bool isList = true;

  Future<void> _loadMarketOffers() async {
    final tags = <String>[
      _currentCategory.name,
      if (_selectedSubCategory != null) _selectedSubCategory!,
      if (_selectedSubSubCategory != null) _selectedSubSubCategory!,
    ];

    CollectionReference offersRef = _offersController.firestore.collection(
      "offers",
    );

    Query query = offersRef
        .where("market", isEqualTo: widget.market.label)
        .where("tags", arrayContainsAny: tags);

    // ✅ Add area filter only if areas list is not empty
    if (areas.isNotEmpty) {
      if (areas.length <= 10) {
        query = query.where("area", whereIn: areas);
      } else {
        debugPrint("⚠️ Too many areas selected for Firestore whereIn filter");
      }
    }

    // print("tags: $tags");
    // print("areas: $areas");
    // print("query: ${query.parameters}");

    await _offersController.fetchOffers(query, context: context);
  }

  @override
  void initState() {
    super.initState();
    // Initialize _currentCategory with the first category or an empty CategoryModel if the list is empty.
    _currentCategory =
        widget.market.categories.isNotEmpty
            ? widget.market.categories[0]
            : CategoryModel(name: "");
    _loadMarketOffers(); // ✅
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.market.categories.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(widget.market.label),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                bottom:
                    widget.market.categories.isEmpty
                        ? null
                        : TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          tabs:
                              widget.market.categories
                                  .map((category) => Tab(text: category.name))
                                  .toList(),
                          onTap: (index) {
                            //listen to tab changes here
                            setState(() {
                              _selectedTabIndex = index; // update selected tab
                              _currentCategory =
                                  widget.market.categories[index];
                              _selectedSubCategory = null; // Clear selections
                              _selectedSubSubCategory = null;
                              _selectedCategoryModel = null;
                            });
                            _loadMarketOffers();
                          },
                        ),
                actions: [
                  IconButton(
                    color: areas.length > 1 ? AppColors.primaryColor : null,
                    onPressed: () async {
                      final selectedAreas =
                          await showModalBottomSheet<List<String>>(
                            shape: RoundedRectangleBorder(),
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8,
                                child: AreaSelectionBottomSheet(
                                  initialSelectedAreas: areas,
                                ),
                              );
                            },
                          );

                      if (selectedAreas != null && selectedAreas.isNotEmpty) {
                        //  ADD THIS LINE:
                        setState(() {
                          areas.clear(); // Clear the existing list
                          areas.addAll(selectedAreas); // Add the new areas
                        });
                        _loadMarketOffers();
                      }
                    },
                    icon: Icon(UIcons.regularRounded.settings_sliders),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(UIcons.regularRounded.search),
                  ),
                  gap(width: 8),
                ],
              ),
            ];
          },
          body: ListView(
            //build the listview here
            padding: EdgeInsets.zero,
            children: [
              gap(height: 10),
              SingleChildScrollView(
                // Make the sub-category chips scrollable
                scrollDirection: Axis.horizontal,
                padding: Dimensions.bodyPadding,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _buildSubCategoryChips(
                    _currentCategory,
                  ), //use current category
                ),
              ),
              if (_selectedSubCategory != null &&
                  _selectedCategoryModel != null &&
                  _hasSubSubcategories(_selectedCategoryModel!)) ...[
                //check here
                const Divider(),
                SingleChildScrollView(
                  // Make the sub-sub-category chips scrollable
                  scrollDirection: Axis.horizontal,
                  padding: Dimensions.bodyPadding,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _buildSubSubCategoryChips(
                      _selectedCategoryModel!,
                    ),
                  ),
                ),
              ],
              widget.market.categories.isEmpty
                  ? SizedBox()
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ListTile(
                      //   contentPadding: EdgeInsets.zero,
                      //   title: Padding(
                      //     padding: Dimensions.bodyPadding.copyWith(bottom: 10),
                      //     child: Text(
                      //       "عروض مُعززة",
                      //       style: Theme.of(context).textTheme.titleMedium,
                      //     ),
                      //   ),
                      //   subtitle: SizedBox(
                      //     height: 250,
                      //     child: ListView.separated(
                      //       scrollDirection: Axis.horizontal,
                      //       itemCount: 3,
                      //       padding: Dimensions.bodyPadding,
                      //       separatorBuilder:
                      //           (context, index) => gap(width: 10),
                      //       itemBuilder: (context, index) => const Offer(),
                      //     ),
                      //   ),
                      // ),
                      gap(height: 16),
                      Padding(
                        padding: Dimensions.bodyPadding.copyWith(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'تصفح عروض: ${_selectedSubCategory ?? _currentCategory.name}${_selectedSubSubCategory != null ? " > $_selectedSubSubCategory" : ""}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  color: isList ? AppColors.primaryColor : null,
                                  onPressed: () {
                                    isList = true;
                                    setState(() {});
                                  },
                                  icon: Icon(UIcons.regularRounded.sort),
                                ),
                                IconButton(
                                  color:
                                      !isList ? AppColors.primaryColor : null,
                                  onPressed: () {
                                    isList = false;
                                    setState(() {});
                                  },
                                  icon: Icon(UIcons.regularRounded.apps),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ValueListenableBuilder<List<OfferModel>>(
                valueListenable: _offersController.marketOffers,
                builder: (context, marketOffers, child) {
                  return marketOffers.isEmpty
                      ? Padding(
                        padding: Dimensions.bodyPadding,
                        child: Row(
                          children: [
                            shimmerContainer(
                              context,
                              height: 265,
                              width: 265 * 1.1,
                            ),
                          ],
                        ),
                      )
                      : SafeArea(
                        top: false,
                        child:
                            isList
                                ? ListView.separated(
                                  padding: Dimensions.bodyPadding,
                                  itemCount:
                                      _offersController
                                          .marketOffers
                                          .value
                                          .length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (context, index) => gap(height: 10),
                                  itemBuilder:
                                      (context, index) =>
                                          OfferTile(offer: marketOffers[index]),
                                )
                                : GridView.builder(
                                  padding: Dimensions.bodyPadding,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 1 / 1.3,
                                      ),
                                  itemCount:
                                      _offersController
                                          .marketOffers
                                          .value
                                          .length,
                                  itemBuilder:
                                      (context, index) =>
                                          Offer(offer: marketOffers[index]),
                                ),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSubCategoryChips(CategoryModel category) {
    List<Widget> chips = [];

    if (category.subItems != null && category.subItems!.isNotEmpty) {
      chips.addAll(
        category.subItems!.map((subCategory) {
          final isSelected = _selectedSubCategory == subCategory;
          return ChoiceChip(
            label: Text(subCategory),
            selected: isSelected,
            onSelected: (bool selected) {
              setState(() {
                _selectedSubCategory = selected ? subCategory : null;
                _selectedSubSubCategory =
                    null; // Clear sub-sub when main category changes.
                if (selected) {
                  _selectedCategoryModel = category;
                } else {
                  _selectedCategoryModel = null;
                }
              });
              _loadMarketOffers();
            },
          );
        }),
      );
    } else if (category.children != null && category.children!.isNotEmpty) {
      chips.addAll(
        category.children!.map((childCategory) {
          final isSelected = _selectedSubCategory == childCategory.name;
          return ChoiceChip(
            label: Text(childCategory.name),
            selected: isSelected,
            onSelected: (bool selected) {
              setState(() {
                _selectedSubCategory = selected ? childCategory.name : null;
                _selectedSubSubCategory = null;
                if (selected) {
                  _selectedCategoryModel = category;
                } else {
                  _selectedCategoryModel = null;
                }
              });
              _loadMarketOffers();
            },
          );
        }),
      );
    }
    return chips;
  }

  List<Widget> _buildSubSubCategoryChips(CategoryModel category) {
    List<Widget> chips = [];

    // Find the selected subcategory (either from subItems or children)
    String selectedSub = _selectedSubCategory ?? "";
    CategoryModel? selectedChildCategory;

    if (category.subItems?.contains(selectedSub) ?? false) {
      // No sub-subcategories for direct subItems
      return [];
    } else if (category.children != null) {
      selectedChildCategory = category.children!.firstWhere(
        (child) => child.name == selectedSub,
        orElse: () => CategoryModel(name: ""),
      );
    }

    if (selectedChildCategory != null &&
        selectedChildCategory.subItems != null &&
        selectedChildCategory.subItems!.isNotEmpty) {
      chips.addAll(
        selectedChildCategory.subItems!.map((subSubCategory) {
          final isSelected = _selectedSubSubCategory == subSubCategory;
          return ChoiceChip(
            label: Text(subSubCategory),
            selected: isSelected,
            onSelected: (bool selected) {
              setState(() {
                _selectedSubSubCategory = selected ? subSubCategory : null;
              });
              _loadMarketOffers();
            },
          );
        }),
      );
    } else {
      return [];
    }

    return chips;
  }

  bool _hasSubSubcategories(CategoryModel category) {
    String selectedSub = _selectedSubCategory ?? "";
    CategoryModel? selectedChildCategory;

    if (category.subItems?.contains(selectedSub) ?? false) {
      return false;
    } else if (category.children != null) {
      selectedChildCategory = category.children!.firstWhere(
        (child) => child.name == selectedSub,
        orElse: () => CategoryModel(name: ""),
      );
    }
    return selectedChildCategory != null &&
        selectedChildCategory.subItems != null &&
        selectedChildCategory.subItems!.isNotEmpty;
  }
}
