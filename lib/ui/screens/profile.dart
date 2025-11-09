import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/offer_controller.dart';
import 'package:hafar_market_app/models/user/user.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/card.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:uicons/uicons.dart';

class Profile extends StatefulWidget {
  final UserDTO user;
  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final OfferController _offersController = OfferController();

  @override
  void initState() {
    super.initState();
    Query query = _offersController.firestore
        .collection("offers")
        .where("userId", isEqualTo: widget.user.userId);
    _offersController.fetchOffers(query, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("الملف الشخصي")),
      body: Padding(
        padding: Dimensions.bodyPadding,
        child: ListView(
          children: [
            gap(height: 15),
            UICard(
              child: Padding(
                padding: Dimensions.bodyPadding.copyWith(top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      foregroundImage: AssetImage("assets/images/avatar.webp"),
                    ),
                    gap(height: 10),
                    Text(
                      widget.user.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if(widget.user.bio != null && widget.user.bio!.isNotEmpty)
                    Text(widget.user.bio!),
                    gap(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        OutlinedButton.icon(
                          onPressed: null,
                          label: Text("مشاركة"),
                          icon: Icon(UIcons.regularRounded.redo),
                        ),
                        gap(width: 10),
                        OutlinedButton.icon(
                          onPressed: null,
                          label: Text("اتصال"),
                          icon: Icon(UIcons.regularRounded.call_outgoing),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            gap(height: 16),
            // ListTile(
            //   contentPadding: EdgeInsets.zero,
            //   title: Padding(
            //     padding: const EdgeInsets.only(bottom: 10),
            //     child: Text(
            //       "إعلاناتي",
            //       style: Theme.of(context).textTheme.titleMedium,
            //     ),
            //   ),
            //   subtitle: ListView.separated(
            //     itemCount: 2,
            //     shrinkWrap: true,
            //     physics: NeverScrollableScrollPhysics(),
            //     separatorBuilder: (context, index) => gap(height: 10),
            //     itemBuilder: (context, index) => const OfferTile(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
