import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/market.dart';
import 'package:hafar_market_app/ui/widget/market.dart';

class OfferMarket extends StatefulWidget {
  const OfferMarket({super.key});

  @override
  State<OfferMarket> createState() => _OfferMarketState();
}

class _OfferMarketState extends State<OfferMarket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("عرض جديد"),
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
                    "حدد نوع العرض",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                subtitle: SafeArea(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.75/1,
                    ),
                    itemCount: markets.length,
                    itemBuilder: (context, index) {
                      final market = markets[index];
                      return MarketTile(market: market);
                    },
                  ),
                ),
              );
              }
            }
          ),
        ],
      ),
    );
  }
}