import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/bloc/music_list/music_list_bloc.dart';
import 'package:music_player/bloc/music_player/music_player_bloc.dart';
import 'package:music_player/enumerations/locale_enum.dart';
import 'package:music_player/localizations/locale_helper.dart';
import 'package:music_player/localizations/music_player_localization.dart';
import 'package:music_player/resources/color_resources.dart';
import 'package:music_player/resources/str_resources.dart';
import 'package:music_player/screens/music_player.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) {
      exit(1);
    }
  };

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MusicPlayerApp());
  });
}

class MusicPlayerApp extends StatefulWidget {
  const MusicPlayerApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MusicPlayerAppState? state = context.findAncestorStateOfType<
        _MusicPlayerAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MusicPlayerApp> createState() => _MusicPlayerAppState();
}

class _MusicPlayerAppState extends State<MusicPlayerApp> {
  Locale _currentLocale = LocaleEnum.english.locale;

  @override
  void didChangeDependencies() {
    LocaleHelper.getLocale().then((locale) {
      setState(() {
        _currentLocale = locale;
      });
    });
    super.didChangeDependencies();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: !kReleaseMode,
      title: StrRes.appName,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.light,
        primaryColor: ColorRes.primary,
        textTheme: const TextTheme(
          headline1: TextStyle(),
          headline2: TextStyle(),
          headline3: TextStyle(),
          headline4: TextStyle(),
          headline5: TextStyle(),
          headline6: TextStyle(),
          subtitle1: TextStyle(),
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
          caption: TextStyle(),
          button: TextStyle(),
          subtitle2: TextStyle(),
          overline: TextStyle(),
        ).apply(
          bodyColor: ColorRes.primary,
          displayColor: ColorRes.primary,
        ),
      ),
      locale: _currentLocale,
      supportedLocales: LocaleEnum.supportedLanguageInLocale(),
      localizationsDelegates: const [
        MusicPlayerLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>  MusicListBloc(),
          ),
          BlocProvider(
            create: (context) =>  MusicPlayerBloc(AudioPlayer()),
          ),
        ],
        child: const MusicPlayerScreen(),
      ),
    );
  }

  setLocale(Locale locale) {
    LocaleHelper.setLocale(locale.languageCode).then((value) {
      setState(() {
        _currentLocale = locale;
      });
    });
  }
}

