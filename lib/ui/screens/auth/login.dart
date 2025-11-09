import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/user/auth_controller.dart';
import 'package:hafar_market_app/controllers/user/user_controller.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  AuthController authController = AuthController();

  TextEditingController phoneNumber = TextEditingController();

  bool _notActive = false;

  Future<void> _signIn() async {
    setState(() {
      _notActive = true;
    });

    authController.signInWithPhone(context, phoneNumber.text).then((v) {
      setState(() {
        _notActive = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
              "مرحباً بعودتك! سجل دخولك الى حسابك في سوق الحفر",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              "تسجيل الدخول او انشاء حساب",
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
                    controller: phoneNumber,
                    decoration: InputDecoration(
                      labelText: "رقم الهاتف",
                      hintText: "05x xxx xxxx",
                    ),
                    maxLength: 10,
                    onChanged: (value) {
                      setState(() {});
                    },
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
                "تأكد من إدخال رقم هاتف سعودي بشكل صحيح\nليتم إرسال رسالة التحقق",
                textAlign: TextAlign.center,
              ),
              gap(height: 15),
              SizedBox(
                height: 55,
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      !_notActive && phoneNumber.text.length == 10
                          ? _signIn
                          : null,
                  child: Text("التالي"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
