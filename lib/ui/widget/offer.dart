import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/offer_model.dart';
import 'package:hafar_market_app/ui/screens/offer_page.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';
import 'package:hafar_market_app/utils/format_timestamp.dart';
import 'package:hafar_market_app/ui/widget/enhanced_badge.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';

class Offer extends StatelessWidget {
  final OfferModel offer;
  const Offer({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => OfferPage(offer: offer)),
        );
      },
      child: AspectRatio(
        aspectRatio: 1 / 1.1,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            border: Border.all(
              width: 1,
              color:
                  Theme.of(
                    context,
                  ).inputDecorationTheme.enabledBorder!.borderSide.color,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: offer.pictures[0],
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              color: Theme.of(context).colorScheme.surface,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        errorWidget:
                            (context, url, error) => Image.asset(
                              "assets/images/placeholder.jpg",
                              fit: BoxFit.cover,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 10,
                        right: 10,
                        left: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(offer.market),
                              Opacity(
                                opacity: 0.75,
                                child: Text(
                                  " | ${formatTimestamp(offer.createdAt)}",
                                ),
                              ),
                            ],
                          ),
                          Text(
                            offer.content,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(child: SizedBox()),
                          offer.price != null
                              ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    offer.price!.toString(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium!.copyWith(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  gap(width: 5),
                                  Image.asset(
                                    "assets/images/riyal.png",
                                    width: 15,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              offer.enhanced == true ? EnhancedBadge() : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class OfferTile extends StatelessWidget {
  final OfferModel offer;
  const OfferTile({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => OfferPage(offer: offer)),
        );
      },
      child: AspectRatio(
        aspectRatio: 2.5 / 1,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            border: Border.all(
              width: 1,
              color:
                  Theme.of(
                    context,
                  ).inputDecorationTheme.enabledBorder!.borderSide.color,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: offer.pictures[0],
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              color: Theme.of(context).colorScheme.surface,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        errorWidget:
                            (context, url, error) => Image.asset(
                              "assets/images/placeholder.jpg",
                              fit: BoxFit.cover,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 10,
                        right: 10,
                        left: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(offer.market),
                              Opacity(
                                opacity: 0.75,
                                child: Text(
                                  " | ${formatTimestamp(offer.createdAt)}",
                                ),
                              ),
                            ],
                          ),
                          Text(
                            offer.content,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(child: SizedBox()),
                          offer.price != null
                              ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    offer.price!.toString(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium!.copyWith(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  gap(width: 5),
                                  Image.asset(
                                    "assets/images/riyal.png",
                                    width: 15,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              offer.enhanced == true ? EnhancedBadge() : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResult extends StatelessWidget {
  final String content;
  final String market;
  final String? picture;
  final int? price;
  const SearchResult({
    super.key,
    required this.content,
    required this.market,
    this.picture,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      contentPadding: EdgeInsets.zero,
      leading:
          picture != null
              ? ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(picture!, fit: BoxFit.cover),
                ),
              )
              : null,
      title: Text(content, style: Theme.of(context).textTheme.titleMedium),
      subtitle: price != null
              ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    price.toString(),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.primaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  gap(width: 3),
                  Image.asset(
                    "assets/images/riyal.png",
                    width: 12,
                    color: AppColors.primaryColor,
                  ),
                ],
              )
              : null,
      trailing: Text(market)
    );
  }
}
