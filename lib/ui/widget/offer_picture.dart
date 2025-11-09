import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OfferPicture extends StatelessWidget {
  final String pictureUrl;
  const OfferPicture({super.key, required this.pictureUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color:
                Theme.of(
                  context,
                ).inputDecorationTheme.enabledBorder!.borderSide.color,
          ),
        ),
        child: CachedNetworkImage(
                          imageUrl: pictureUrl,
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
    );
  }
}
