import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafar_market_app/ui/widget/adaptive_action.dart';

class ErrorHandler {
  FirebaseCrashlytics? _crashlytics;

  ErrorHandler() {
    // Lazy initialization - only access Crashlytics if Firebase is initialized
    try {
      _crashlytics = FirebaseCrashlytics.instance;
      _crashlytics?.setCrashlyticsCollectionEnabled(true);
    } catch (e) {
      // Firebase not initialized yet, Crashlytics will be null
      debugPrint("Crashlytics not available: $e");
    }
  }

  void recordError(Object error, StackTrace stackTrace) {
    // Log the error to your Crashlytics or monitoring tool
    _crashlytics?.recordError(error, stackTrace);
    debugPrint("$error, $stackTrace");
  }

  void handleUnknownError(
      Object error, StackTrace stackTrace, BuildContext context) {
    _crashlytics?.recordError(error, stackTrace);

    String errorMessage = "حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.";
    String? errorCode;

    if (error is FirebaseException) {
      errorCode = error.code;
      errorMessage = "خطأ: ${error.message} (رمز الخطأ: $errorCode)";
    } else if (error is PlatformException) {
      errorCode = error.code;
      errorMessage = "خطأ في النظام: ${error.message} (رمز: $errorCode)";
    }

    showSnackBar(context, errorMessage);
    debugPrint("Error: $errorCode, $error, $stackTrace");
  }

  void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        backgroundColor: Theme.of(context).colorScheme.surface,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        content: Text(
          content,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }

  void showAlert(BuildContext context, String title, String message,
      {List<Widget>? actions}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(title, style: TextStyle(fontFamily: "IBMPlexSans")),
        content: Text(message, style: TextStyle(fontFamily: "IBMPlexSans")),
        actions: actions ??
            [
              adaptiveAction(
                context,
                onPressed: () => Navigator.pop(context),
                child: const Text("موافق",
                    style: TextStyle(fontFamily: "IBMPlexSans")),
              ),
            ],
      ),
    );
  }
}
