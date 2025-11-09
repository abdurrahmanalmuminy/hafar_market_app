import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/user/user.dart';
import 'package:hafar_market_app/ui/screens/profile.dart';
import 'package:hafar_market_app/ui/widget/card.dart';
import 'package:hafar_market_app/ui/widget/user_avatar.dart';

class AccountTile extends StatelessWidget {
  final Widget actionButton;
  final UserDTO? user;
  const AccountTile({super.key, required this.actionButton, this.user});

  @override
  Widget build(BuildContext context) {
    return user != null
        ? UICard(
          child: ListTile(
            onTap:
                user != null
                    ? () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => Profile(user: user!),
                        ),
                      );
                    }
                    : null,
            shape: RoundedRectangleBorder(),
            leading: UserAvatar(imageUrl: user!.photoUrl),
            title: Text(
              user!.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              user!.phoneNumber,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.right,
            ),
            trailing: actionButton,
          ),
        )
        : SizedBox();
  }
}
