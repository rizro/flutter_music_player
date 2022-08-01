import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/enumerations/locale_enum.dart';

class MusicPlayerLocalization {
  MusicPlayerLocalization(this.locale);

  final Locale locale;
  static MusicPlayerLocalization? of(BuildContext context) {
    return Localizations.of<MusicPlayerLocalization>(context, MusicPlayerLocalization);
  }

  Map<String, String> _localizedValues = <String, String>{};

  Future<void> load() async {
    String jsonStringValues = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedValues[key] ?? '';
  }

  Future<String> translateFromSpecificLocale(Locale locale, String key) async {
    String jsonStringValues = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));
    return _localizedValues[key] ?? '';
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<MusicPlayerLocalization> delegate = _MusicPlayerLocalizationsDelegate();
}

class _MusicPlayerLocalizationsDelegate extends LocalizationsDelegate<MusicPlayerLocalization> {
  const _MusicPlayerLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return LocaleEnum.supportedLanguageInStr().contains(locale.languageCode);
  }

  @override
  Future<MusicPlayerLocalization> load(Locale locale) async {
    MusicPlayerLocalization localization = MusicPlayerLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<MusicPlayerLocalization> old) => false;
}