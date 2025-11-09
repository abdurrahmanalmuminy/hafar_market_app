import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/market.dart';
import 'package:hafar_market_app/ui/screens/market_page.dart';
import 'package:hafar_market_app/ui/screens/new_offer.dart/offer_category.dart';
import 'package:hafar_market_app/ui/widget/card.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';

class MarketCircle extends StatelessWidget {
  final MarketModel market;
  const MarketCircle({super.key, required this.market});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => MarketPage(market: market)),
        );
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                border: Border.all(
                  width: 1,
                  color:
                      Theme.of(
                        context,
                      ).inputDecorationTheme.enabledBorder!.borderSide.color,
                ),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.05),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Icon(
                market.icon,
                color: Theme.of(context).colorScheme.onSurface,
                size: 25,
              ),
            ),
            Text(market.label),
          ],
        ),
      ),
    );
  }
}

class MarketTile extends StatelessWidget {
  final MarketModel market;
  const MarketTile({super.key, required this.market});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(CupertinoPageRoute(
            builder: (context) => OfferCategory(market: market, marketLabel: market.label,))); 
      },
      child: UICard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              market.icon,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            gap(width: 5),
            Text(market.label, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
