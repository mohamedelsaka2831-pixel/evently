import 'package:flutter/material.dart';


class LocaleProvider extends ChangeNotifier {
  bool _isArabic = false;

  bool get isArabic => _isArabic;
  Locale get locale => _isArabic ? const Locale('ar') : const Locale('en');
  TextDirection get textDirection =>
      _isArabic ? TextDirection.rtl : TextDirection.ltr;

  void setArabic(bool value) {
    _isArabic = value;
    notifyListeners();
  }

  void toggle() {
    _isArabic = !_isArabic;
    notifyListeners();
  }
}
