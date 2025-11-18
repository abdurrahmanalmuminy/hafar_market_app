import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/trend_model.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/card.dart';
import 'package:hafar_market_app/ui/widget/offer_picture.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:uicons/uicons.dart';

class TrendPage extends StatefulWidget {
  final TrendModel trend;
  const TrendPage({super.key, required this.trend});

  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              // Share functionality
              // if (widget.trend.id.isNotEmpty) {
              //   final uri = await DynamicLinksService(navigatorKey: rootNavigatorKey)
              //       .buildTrendLink(widget.trend.id);
              //   Share.share(uri.toString());
              // }
            },
            icon: Icon(UIcons.regularRounded.redo),
          ),
          IconButton(
            onPressed: () {
              // Like functionality
            },
            icon: Icon(UIcons.regularRounded.heart),
          ),
          gap(width: 8),
        ],
      ),
      body: ListView(
        children: [
          widget.trend.pictures.isNotEmpty
              ? Column(
                  children: [
                    gap(height: 16),
                    CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        height: 280,
                        viewportFraction: 0.9,
                        enableInfiniteScroll: false,
                        autoPlay: widget.trend.pictures.length > 1,
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
                      items: widget.trend.pictures.map((pictureUrl) {
                        return OfferPicture(
                          pictureUrl: pictureUrl,
                        );
                      }).toList(),
                    ),
                    DotsIndicator(
                      dotsCount: widget.trend.pictures.length,
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
                    Text(
                      widget.trend.subtitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    gap(height: 16),
                    Text(
                      widget.trend.content,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
          gap(height: 16),
        ],
      ),
    );
  }
}

