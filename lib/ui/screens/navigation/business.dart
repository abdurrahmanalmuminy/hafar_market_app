import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/market.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/commercial_item.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:uicons/uicons.dart';

class Business extends StatefulWidget {
  const Business({super.key});

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business> {
  int _selectedTabIndex = 0;
  late Future<List<Tab>> _tabsFuture;

  @override
  void initState() {
    super.initState();
    _tabsFuture = loadMarkets().then((markets) {
      return markets.map((market) => Tab(text: market.label)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 16,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                title: Text("منصة الأعمال"),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48.0),
                  child: FutureBuilder<List<Tab>>(
                    future: _tabsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No markets available.'),
                        );
                      } else {
                        return TabBar(
                          isScrollable: true,
                          tabs: snapshot.data!,
                          onTap: (index) {
                            setState(() {
                              _selectedTabIndex = index;
                            });
                          },
                        );
                      }
                    },
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(UIcons.regularRounded.search),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(UIcons.regularRounded.layer_plus),
                    label: Text("اعلن هنا"),
                  ),
                  gap(width: 8),
                ],
              ),
            ];
          },
          body: FutureBuilder<List<Tab>>(
            // change the FutureBuilder type to List<Tab>
            future: _tabsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No markets available.'));
              } else {
                // Now snapshot.data is List<Tab>
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    gap(height: 16),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 250,
                        viewportFraction: 0.9,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayCurve: Curves.easeInOutCubic,
                        onPageChanged: (index, reason) {},
                      ),
                      items: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 7.5,
                            left: 7.5,
                            bottom: 10,
                          ),
                          child: CommercialItem(),
                        ),
                      ],
                    ),
                    DotsIndicator(
                      dotsCount: 3,
                      position: 1,
                      decorator: DotsDecorator(
                        color: Theme.of(context).dividerTheme.color!,
                        activeColor: AppColors.primaryColor,
                      ),
                    ),
                    gap(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: Dimensions.bodyPadding,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1 / 1.3,
                      ),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return CommercialItem();
                      },
                    ),
                    gap(height: 100),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
