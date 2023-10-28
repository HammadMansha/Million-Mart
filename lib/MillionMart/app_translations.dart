import 'dart:ui';

import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartHome.dart';
import 'package:millionmart_cleaned/MillionMart/lang/en_US.dart';
import 'package:millionmart_cleaned/MillionMart/lang/ur_PK.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends Translations {
  // Default locale

  static final locale = getLang().toString() == "English" ? Locale('en', 'US') : Locale('ur', 'PK');

  // fallbackLocale saves the day when the locale gets in trouble
  static final fallbackLocale = Locale('en', 'US');

  // Supported languages
  // Needs to be same order with locales
  static final langs = [
    'English',
    'اردو',
  ];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    Locale('en', 'US'),
    Locale('ur', 'PK'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS, // lang/en_us.dart
        'ur_PK': urPK, // lang/ur_pk.dart
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) async{
    final SharedPreferences _prefs = await Constants.prefs;
    _prefs.setString('lang', lang);
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale!);

  }

  // Finds language in `langs` list and returns it as Locale
  Locale? _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }
}

Future<String?> getLang()async{
  final SharedPreferences _prefs = await Constants.prefs;
  print('Shared pref Lang ${_prefs.getString('lang')}');
  return _prefs.getString('lang');
}