import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    fontFamily: "SST",
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
      secondary: AppColors.primaryColor,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.black.withValues(alpha: 0.1),
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: TextTheme(titleLarge: TextStyle(fontWeight: FontWeight.bold)),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.5)),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
    ),
    dividerTheme: DividerThemeData(color: Colors.black.withValues(alpha: 0.10)),
    searchBarTheme: SearchBarThemeData(
      hintStyle: WidgetStatePropertyAll(
        TextStyle(color: Colors.black.withValues(alpha: 0.5)),
      ),
      elevation: WidgetStatePropertyAll(0),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      side: WidgetStatePropertyAll(
        BorderSide(color: Colors.black.withValues(alpha: 0.25)),
      ),
    ),
    canvasColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight.withValues(alpha: 0.85),
      centerTitle: false,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.backgroundLight.withValues(alpha: 0.85),
      elevation: 0,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      linearTrackColor: Colors.black.withValues(alpha: 0.2),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.black)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: "SST",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      selectedTileColor: AppColors.primaryColor.withValues(alpha: 0.1),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconSize: WidgetStatePropertyAll(20)),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      showCheckmark: false,
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return BorderSide.none;
        }
        return BorderSide(color: Colors.black.withValues(alpha: 0.2));
      }),
    ),
    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.black.withValues(alpha: 0.15),
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      tabAlignment: TabAlignment.center,
    ),
  );

  static final ThemeData dark = ThemeData(
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    fontFamily: "SST",
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
      secondary: AppColors.primaryColor,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white.withValues(alpha: 0.1),
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: TextTheme(titleLarge: TextStyle(fontWeight: FontWeight.bold)),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
      filled: true,
      fillColor: Colors.black,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
    ),
    dividerTheme: DividerThemeData(color: Colors.white.withValues(alpha: 0.10)),
    disabledColor: AppColors.primaryColor.withValues(alpha: 0.25),
    searchBarTheme: SearchBarThemeData(
      hintStyle: WidgetStatePropertyAll(
        TextStyle(color: Colors.white.withValues(alpha: 0.5)),
      ),
      elevation: WidgetStatePropertyAll(0),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      side: WidgetStatePropertyAll(
        BorderSide(color: Colors.white.withValues(alpha: 0.25)),
      ),
    ),
    canvasColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark.withValues(alpha: 0.85),
      centerTitle: false,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.backgroundDark.withValues(alpha: 0.85),
      elevation: 0,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      linearTrackColor: Colors.white.withValues(alpha: 0.2),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: "SST",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      selectedTileColor: AppColors.primaryColor.withValues(alpha: 0.1),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconSize: WidgetStatePropertyAll(20)),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      showCheckmark: false,
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return BorderSide.none;
        }
        return BorderSide(color: Colors.white.withValues(alpha: 0.2));
      }),
    ),
    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.white.withValues(alpha: 0.15),
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      tabAlignment: TabAlignment.center,
    ),
  );
}
