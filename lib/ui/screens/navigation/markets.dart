import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/market.dart';
import 'package:hafar_market_app/ui/screens/search_results.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/market.dart';
import 'package:uicons/uicons.dart';

class Markets extends StatefulWidget {
  const Markets({super.key});

  @override
  State<Markets> createState() => _MarketsState();
}

class _MarketsState extends State<Markets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("الأسواق"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: Dimensions.bodyPadding.copyWith(bottom: 10),
            child: SearchBar(
              leading: Icon(UIcons.regularRounded.search, size: 20),
              hintText: "إبحث في سوق الحفر",
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => SearchResults()),
                );
              },
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          FutureBuilder(
            future: loadMarkets(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                ); // Loading indicator
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                ); // Error state
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No markets available.'),
                ); // No data available
              } else {
                var markets =
                    snapshot.data!; // List of markets loaded from the JSON file

                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "وش تدور؟",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  subtitle: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: markets.length,
                    itemBuilder: (context, index) {
                      final market = markets[index];
                      return MarketCircle(market: market);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
