import 'package:flutter/cupertino.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('fr'),
  ];

  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'hi':
        return 'Hindi';
      default:
        return 'English';
      // return 'French';
    }
  }
}
