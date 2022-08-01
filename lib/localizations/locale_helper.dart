import 'package:flutter/material.dart';
import 'package:music_player/enumerations/locale_enum.dart';
import 'package:music_player/localizations/music_player_localization.dart';
import 'package:music_player/utils/devlog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleHelper{
  static const String languageCodeStr = 'languageCode';

  static Future<Locale> setLocale(String languageCode) async {
    DevLog.d(DevLog.arr, 'Set Locale : $languageCode');
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool setResult = await _prefs.setString(languageCodeStr, languageCode);
    DevLog.d(DevLog.arr, 'Set Locale Result : $setResult');
    return LocaleEnum.getLocaleEnum(languageCode).locale;
  }

  static Future<Locale> getLocale() async {
    DevLog.d(DevLog.arr, 'Get Locale');
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(languageCodeStr) ?? LocaleEnum.english.locale.languageCode;
    DevLog.d(DevLog.arr, 'Get Locale Result : $languageCode');
    return LocaleEnum.getLocaleEnum(languageCode).locale;
  }

  static String getTranslated(BuildContext context, String key) {
    return MusicPlayerLocalization.of(context)?.translate(key) ?? '';
  }

  static Future<String>? getTranslatedFromSpecificLocale(BuildContext context, Locale locale, String key) {
    return MusicPlayerLocalization.of(context)?.translateFromSpecificLocale(locale, key);
  }
}