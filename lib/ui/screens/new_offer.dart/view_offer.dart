import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/offer_controller.dart';
import 'package:hafar_market_app/models/offer_model.dart';
import 'package:hafar_market_app/models/user/user.dart';
import 'package:hafar_market_app/providers/user_provider.dart';
import 'package:hafar_market_app/ui/screens/new_offer.dart/offer_category.dart';
import 'package:hafar_market_app/ui/screens/new_offer.dart/offer_details.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/offer.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:provider/provider.dart';

class ViewOffer extends StatefulWidget {
  const ViewOffer({super.key, this.pictureUrls = const []});

  final List<String> pictureUrls;

  @override
  State<ViewOffer> createState() => _ViewOfferState();
}

class _ViewOfferState extends State<ViewOffer> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final UserDTO? currentUser = userProvider.currentUser;

    OfferController offerController = OfferController();

    OfferModel offer = OfferModel(
      id: "",
      userId: currentUser?.userId ?? "",
      content: contentController.text,
      pictures: widget.pictureUrls.isNotEmpty
          ? widget.pictureUrls
          : [
              "https://postcdn.haraj.com.sa/userfiles30/2025-06-25/1350x1800_D51DDEC3-6A46-4101-8A92-BAB5E669C499.jpg-900.webp",
            ],
      market: selectionMap.market ?? "",
      category: selectionMap.category ?? "",
      tags: tags + generatedTags,
      createdAt: Timestamp.now(),
      price: double.tryParse(priceController.text),
      area: selectedArea,
    );

    bool _loading = false;

    Future<void> _createOffer() async {
      setState(() {
        _loading = true;
      });

      offerController.createOffer(offer, context).then((offer) {
        if (offer != null) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("معاينة العرض")),
      body: ListView(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Opacity(
              opacity: 0.5,
              child: Padding(
                padding: Dimensions.bodyPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "الأحدث في السوق",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: null,
                      child: const Text("اعرض المزيد"),
                    ),
                  ],
                ),
              ),
            ),
            subtitle: SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                padding: Dimensions.bodyPadding,
                separatorBuilder: (context, index) => gap(width: 10),
                itemBuilder:
                    (context, index) => Opacity(
                      opacity: index == 0 ? 1 : 0.5,
                      child: Offer(offer: offer),
                    ),
              ),
            ),
          ),
          gap(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Opacity(
              opacity: 0.5,
              child: Padding(
                padding: Dimensions.bodyPadding.copyWith(bottom: 10),
                child: Text(
                  "إعلاناتي",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            subtitle: ListView.separated(
              padding: Dimensions.bodyPadding,
              itemCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => gap(height: 10),
              itemBuilder:
                  (context, index) => Opacity(
                    opacity: index == 0 ? 1 : 0.5,
                    child: OfferTile(offer: offer),
                  ),
            ),
          ),
        ],
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
                    !_loading
                        ? () {
                          _createOffer();
                        }
                        : null,
                child: Text("أنشئ عرضك"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
