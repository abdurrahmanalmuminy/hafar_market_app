import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hafar_market_app/controllers/error_handler.dart';
import 'package:hafar_market_app/controllers/user/auth_controller.dart';
import 'package:hafar_market_app/firebase_options.dart';
import 'package:hafar_market_app/l10/l10n.dart';
import 'package:hafar_market_app/providers/locale_provider.dart';
import 'package:hafar_market_app/providers/theme_provider.dart';
import 'package:hafar_market_app/providers/user_provider.dart';
import 'package:hafar_market_app/ui/screens/auth/personal_info.dart';
import 'package:hafar_market_app/ui/screens/navigation/navigation.dart';
import 'package:hafar_market_app/ui/screens/welcome.dart';
import 'package:hafar_market_app/ui/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hafar_market_app/services/notification_service.dart';
// import 'package:hafar_market_app/l10n/app_localizations.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint(".env not found or failed to load; continuing without it");
    }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Initialize App Check early
    try {
      await FirebaseAppCheck.instance.activate(
        // Use debug provider on iOS in debug builds (e.g., Simulator). DeviceCheck for release.
        appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.deviceCheck,
        webProvider: ReCaptchaV3Provider(''),
      );
    } catch (e) {
      debugPrint('App Check activation failed: $e');
    }
    // Initialize dynamic links listener (non-blocking)
    try {
      // await DynamicLinksService(navigatorKey: rootNavigatorKey).init();
    } catch (e) {
      debugPrint('Dynamic links initialization failed: $e');
      // Continue app initialization even if dynamic links fail
    }
    // Initialize Firebase Messaging (non-blocking)
    try {
      await NotificationService().initialize();
    } catch (e) {
      debugPrint('Notification service initialization failed: $e');
      // Continue app initialization even if notifications fail
    }
    final userProvider = UserProvider();
    await userProvider.loadUserFromPreferences();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>.value(value: userProvider),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: MyApp(userProvider: userProvider),
      ),
    );
  } catch (e, stackTrace) {
    final ErrorHandler errorHandler = ErrorHandler();
    errorHandler.recordError(e, stackTrace);
    debugPrint("Initialization error: $e");
    debugPrint("Stacktrace: $stackTrace");

    // Wrap ErrorFallbackApp with necessary providers
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const ErrorFallbackApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final UserProvider userProvider;
  const MyApp({super.key, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      title: "Hafar Market",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return FutureBuilder(
            future: Future.value(AuthController().auth.currentUser),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }

              final firebaseUser = snapshot.data;
              final currentUser = userProvider.currentUser;

              if (firebaseUser != null && currentUser != null) {
                // User is logged in and saved in shared preferences
                return Navigation();
              } else if (firebaseUser != null && currentUser == null) {
                // User is logged in to Firebase but not saved in shared preferences
                return PersonalInfo(
                  userId: firebaseUser.uid,
                  phoneNumber: firebaseUser.phoneNumber ?? "",
                );
              } else {
                // Default to the Welcome page
                return Welcome();
              }
            },
          );
        },
      ),
      supportedLocales: L10n.all,
      locale: Provider.of<LocaleProvider>(context).currentLocale,
    );
  }
}

class ErrorFallbackApp extends StatelessWidget {
  const ErrorFallbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      title: "Hafar Market",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      supportedLocales: L10n.all,
      locale: Provider.of<LocaleProvider>(context).currentLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.error_outline, size: 48),
                SizedBox(height: 12),
                Text('An error occurred during startup'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
