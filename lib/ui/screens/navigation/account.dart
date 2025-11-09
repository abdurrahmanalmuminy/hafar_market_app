import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/more_model.dart';
import 'package:hafar_market_app/models/user/user.dart';
import 'package:hafar_market_app/providers/user_provider.dart';
import 'package:hafar_market_app/ui/screens/new_offer.dart/agreement.dart';
import 'package:hafar_market_app/ui/screens/edit_profile.dart';
import 'package:hafar_market_app/ui/screens/commission/pay_commission.dart';
import 'package:hafar_market_app/ui/screens/profile.dart';
import 'package:hafar_market_app/ui/themes/decorations.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/account_tile.dart';
import 'package:hafar_market_app/ui/widget/info_card.dart';
import 'package:hafar_market_app/ui/widget/more_tile.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uicons/uicons.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final UserDTO? currentUser = userProvider.currentUser;

    List<MoreItemModel> list = [
      MoreItemModel(
        leadingIcon: UIcons.regularRounded.plus,
        label: "أضف عرض",
        onTap: () {
          Navigator.of(
            context,
          ).push(CupertinoPageRoute(builder: (context) => Agreement()));
        },
      ),
      MoreItemModel(
        leadingIcon: UIcons.regularRounded.coins,
        label: "ادفع العمولة",
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (context) => PayCommission(),
            ),
          );
        },
      ),
      MoreItemModel(
        leadingIcon: UIcons.regularRounded.heart,
        label: "المفضلة",
        trailingIcon: UIcons.regularRounded.angle_small_left,
        onTap: () {},
      ),
      MoreItemModel(
        leadingIcon: UIcons.regularRounded.user,
        label: "الملف الشخصي",
        trailingIcon: UIcons.regularRounded.angle_small_left,
        onTap: currentUser != null ? () {
          Navigator.of(
            context,
          ).push(CupertinoPageRoute(builder: (context) => Profile(user: currentUser,)));
        } : null,
      ),
      MoreItemModel(
        leadingIcon: UIcons.regularRounded.redo,
        label: "شارك التطبيق",
        onTap: () {},
      ),
      MoreItemModel(
        leadingIcon: UIcons.regularRounded.shield_check,
        label: "سياسة الخصوصية",
        trailingIcon: UIcons.regularRounded.globe,
      ),
      MoreItemModel(
        leadingIcon: UIcons.regularRounded.interrogation,
        label: "سياسة الإستخدام",
        trailingIcon: UIcons.regularRounded.globe,
      ),
      MoreItemModel(
        leadingIcon: UIcons.regularRounded.headset,
        label: "مركز المساعدة",
        trailingIcon: UIcons.regularRounded.angle_small_left,
      ),
      MoreItemModel(
        leadingIcon: UIcons.regularRounded.sign_out_alt,
        label: "تسجيل الخروج",
      ),
      MoreItemModel(
        leadingIcon: UIcons.regularRounded.trash,
        label: "احذف حسابي",
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("حسابي"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: Dimensions.bodyPadding,
            child: AccountTile(
              user: currentUser,
              actionButton: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => const EditProfile()),
                  );
                },
                icon: Icon(UIcons.regularRounded.pencil, size: 20),
              ),
            ),
          ),
          gap(height: 16),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "القائمة السريعة",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            subtitle: Container(
              decoration: Decorations.defaultDecoration(context),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return MoreTile(item: list[index]);
                },
                separatorBuilder: (context, index) {
                  return Divider(height: 1);
                },
                itemCount: 3,
              ),
            ),
          ),
          gap(height: 16),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "المزيد",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            subtitle: Container(
              decoration: Decorations.defaultDecoration(context),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return MoreTile(
                    item: list[index + 4],
                    isImportant: index > 3,
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(height: 1);
                },
                itemCount: 6,
              ),
            ),
          ),
          gap(height: 16),
          Padding(
            padding: Dimensions.bodyPadding,
            child: InfoCard(
              icon: UIcons.regularRounded.document,
              title: "إطلاق تجريبي",
              subtitle: "رأيك يهمنا، شارك في هذا الإستبيان القصير",
              buttonLabel: "شارك في الاستبيان",
            ),
          ),
          gap(height: 100),
        ],
      ),
    );
  }
}
