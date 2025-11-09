import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/user/auth_controller.dart';
import 'package:hafar_market_app/controllers/user/user_controller.dart';
import 'package:hafar_market_app/providers/user_provider.dart';
import 'package:hafar_market_app/ui/screens/auth/personal_info.dart';
import 'package:hafar_market_app/ui/screens/navigation/navigation.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';

class Otp extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const Otp({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  AuthController authController = AuthController();
  late UserController userController;

  TextEditingController smscode = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userController = UserController(userProvider);
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _loading = true;
    });

    authController.verifyOtp(context, widget.verificationId, smscode.text).then(
      (uid) {
        if (uid != null) {
          userController.initUser(uid, context).then((user) {
            if (user != null) {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => const Navigation(),
                  fullscreenDialog: true,
                ),
              );
            } else {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder:
                      (context) => PersonalInfo(
                        userId: uid,
                        phoneNumber: widget.phoneNumber,
                      ),
                ),
              );
            }
            setState(() {
              _loading = false;
            });
          });
        } else {
          setState(() {
            _loading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final defaultPinTheme = PinTheme(
      width: width / 8,
      height: width / 8,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: Theme.of(context).colorScheme.onSecondary,
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(15),
    );

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Image.asset("assets/branding/hafar_market/logo.png", width: 60),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              "رمز التحقق في طريقه إليك, أدخله الأن لتبدأ التسوق",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              "أدخل رمز التحقق",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          gap(height: 25),
          Padding(
            padding: Dimensions.bodyPadding,
            child: Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              autofocus: true,
              controller: smscode,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (code) {
                _verifyOtp();
              },
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
                "بتسجيل الدخول أو إنشاء حساب جديد، فأنت\nتوافق على سياسة الخصوصية",
                textAlign: TextAlign.center,
              ),
              gap(height: 15),
              SizedBox(
                height: 55,
                width: double.infinity,
                child: FilledButton(
                  onPressed: !_loading ? _verifyOtp : null,
                  child: Text("التحقق"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
