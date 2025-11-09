import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/user/user.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/comment.dart';
import 'package:hafar_market_app/ui/widget/user_avatar.dart';

class OfferComments extends StatefulWidget {
  final UserDTO? user;
  const OfferComments({super.key, this.user});

  @override
  State<OfferComments> createState() => _OfferCommentsState();
}

class _OfferCommentsState extends State<OfferComments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("التعليقات"),),
      body: Padding(
        padding: Dimensions.bodyPadding,
        child: ListView(
          children: [
            Comment(),
          ],
        ),
      ),
      bottomSheet: widget.user != null ? Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          border: Border(
            top: BorderSide(
              color:
                  Theme.of(
                    context,
                  ).inputDecorationTheme.enabledBorder!.borderSide.color,
            ),
          ),
        ),
        child: ListTile(
          minVerticalPadding: 0,
          leading: UserAvatar(
            imageUrl: widget.user!.photoUrl,
          ),
          title: TextFormField(
            autofocus: true,
            decoration: InputDecoration(hintText: "أضف تعليق"),
            onTap: () {
              // Send a comment
              //     .then((_) {
              // TODO: refreash comments
              //     });
            },
          ),
        ),
      ) : SizedBox(),
    );
  }
}