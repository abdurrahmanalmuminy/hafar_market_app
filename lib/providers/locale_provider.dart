import 'package:flutter/material.dart';
import 'package:hafar_market_app/l10/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('ar');

  Locale get currentLocale => _currentLocale;

  void changeLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
  }

  void toggleLocale() {
    final nextIndex = (L10n.all.indexOf(_currentLocale) + 1) % L10n.all.length;
    _currentLocale = L10n.all[nextIndex];
    notifyListeners();
  }
}