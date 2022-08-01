import 'package:flutter/material.dart';

class LocaleEnum{
  final Locale _locale;

  const LocaleEnum._(this._locale);

  Locale get locale => _locale;

  static const LocaleEnum english = LocaleEnum._(Locale('en', 'US'));
  static const LocaleEnum bahasa = LocaleEnum._(Locale('id', 'ID'));

  static const List<LocaleEnum> localeEnumList = [
    english, bahasa
  ];

  static List<String> supportedLanguageInStr(){
    List<String> supportedLanguageList = [];
    for (LocaleEnum localeEnum in localeEnumList){
      supportedLanguageList.add(localeEnum.locale.languageCode);
    }

    return supportedLanguageList;
  }

  static List<Locale> supportedLanguageInLocale(){
    List<Locale> supportedLanguageList = [];
    for (LocaleEnum localeEnum in localeEnumList){
      supportedLanguageList.add(localeEnum.locale);
    }

    return supportedLanguageList;
  }

  static LocaleEnum getLocaleEnum(String code){
    for (LocaleEnum localeEnum in localeEnumList){
      if (localeEnum.locale.languageCode == code){
        return localeEnum;
      }
    }

    return LocaleEnum.english;
  }
}