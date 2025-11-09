import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/user/user_controller.dart';
import 'package:hafar_market_app/models/areas.dart';
import 'package:hafar_market_app/models/user/user.dart';
import 'package:hafar_market_app/providers/user_provider.dart';
import 'package:hafar_market_app/ui/screens/navigation/navigation.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/drop_down.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  final String userId;
  final String phoneNumber;
  const PersonalInfo({
    super.key,
    required this.userId,
    required this.phoneNumber,
  });

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  late UserController userController;
  TextEditingController username = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userController = UserController(userProvider);
  }

  Future<void> _createProfile(UserDTO user) async {
    setState(() {
      _loading = true;
    });

    userController.createUser(user, context).then((createdUser) {
      if (createdUser != null) {
        userController.initUser(createdUser.userId, context).then((loadedUser) {
          if (loadedUser != null) {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (context) => const Navigation(),
                fullscreenDialog: true,
              ),
            );
          } else {
            setState(() {
              _loading = false;
            });
          }
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              "أدخل بياناتك الشخصية لتجربة تسوق مخصصة وسريعة",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              "خطوة أخيرة",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          gap(height: 25),
          Padding(
            padding: Dimensions.bodyPadding,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      labelText: "اسم المستخدم",
                      hintText: "عبدالرحمن حسين",
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  gap(height: 10),
                  DropDown(
                    label: "وين ساكن؟",
                    items: areasList,
                    onChanged: (newValue) {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: Dimensions.bodyPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "بتسجيل الدخول أنت توافق على سياسة الخصوصية",
                textAlign: TextAlign.center,
              ),
              gap(height: 15),
              SizedBox(
                height: 55,
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      !_loading && username.text.isNotEmpty
                          ? () {
                            _createProfile(
                              UserDTO(
                                userId: widget.userId,
                                name: username.text,
                                phoneNumber: widget.phoneNumber,
                                joinedAt: Timestamp.now(),
                              ),
                            );
                          }
                          : null,
                  child: Text("أنشئ حسابك"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
