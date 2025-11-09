import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/error_handler.dart';
import 'package:hafar_market_app/providers/user_provider.dart';
import 'package:hafar_market_app/ui/screens/auth/otp.dart';
import 'package:hafar_market_app/ui/screens/welcome.dart';
import 'package:hafar_market_app/ui/widget/adaptive_action.dart';

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ErrorHandler _errorHandler = ErrorHandler();
  final UserProvider _userProvider = UserProvider();

  Future signInWithPhone(context, String phone) async {
    try {
      String phoneNumber =
          phone.startsWith("0")
              ? phone.replaceFirst("0", "+966")
              : phone.contains("+966")
              ? phone
              : "+966$phone";
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("Verification failed: ${e.code}");
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder:
                  (context) => Otp(
                    verificationId: verificationId,
                    phoneNumber: phoneNumber,
                  ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e, stackTrace) {
      _errorHandler.recordError(e, stackTrace);
      _errorHandler.showAlert(
        context,
        "تسجيل الدخول",
        "فشل تسجيل الدخول باستخدام رقم الهاتف، يرجى المحاولة مرة أخرى",
      );
    }
  }

  Future verifyOtp<String>(
    BuildContext context,
    verificationId,
    smsCode,
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
      return auth.currentUser?.uid;
    } catch (e, stackTrace) {
      _errorHandler.recordError(e, stackTrace);
      _errorHandler.showAlert(
        context,
        "تسجيل الدخول",
        "فشل تسجيل الدخول باستخدام رقم الهاتف، يرجى المحاولة مرة أخرى",
      );
      return null;
    }
  }

  Future<void> signOut(context) async {
    try {
      _errorHandler.showAlert(
        context,
        "تسجيل الخروج",
        "هل تريد بتسجيل الخروج من حسابك؟",
        actions: [
          adaptiveAction(
            context,
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء", style: TextStyle(fontFamily: "IBMPlexSans")),
          ),
          adaptiveAction(
            context,
            onPressed: () async {
              await auth.signOut();
              await _userProvider.clearUserData();
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return Welcome();
                  },
                  fullscreenDialog: true,
                ),
              );
            },
            child: Text(
              "تأكيد",
              style: TextStyle(fontFamily: "IBMPlexSans", color: Colors.red),
            ),
          ),
        ],
      );
    } catch (e, stackTrace) {
      _errorHandler.recordError(e, stackTrace);
      _errorHandler.showAlert(
        context,
        "تسجيل الخروج",
        "فشل تسجيل الخروج. يرجى المحاولة مرة أخرى.",
      );
      throw Exception("Failed to sign out. Please try again.");
    }
  }
}
