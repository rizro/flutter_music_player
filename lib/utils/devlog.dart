import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class DevLog{
  static const String arr = "ARR Log";

  static DevLog? _instance;

  late Logger simpleLogger;
  late Logger defaultLogger;

  DevLog._(){
    simpleLogger = Logger(
      printer: SimplePrinter(
          printTime: false,
          colors: true
      ),
    );

    defaultLogger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        printTime: false,
      ),
    );
  }

  factory DevLog(){
    return _instance ??= DevLog._();
  }

  static void v(String tag, String value){
    if (!kReleaseMode) {
      DevLog().simpleLogger.v('$tag: $value');
    }
  }

  static void d(String tag, String value){
    if (!kReleaseMode) {
      DevLog().simpleLogger.d('$tag: $value');
    }
  }

  static void i(String tag, String value){
    if (!kReleaseMode) {
      DevLog().defaultLogger.i('$tag: $value');
    }
  }

  static void w(String tag, String value){
    if (!kReleaseMode) {
      DevLog().defaultLogger.w('$tag: $value');
    }
  }

  static void e(String tag, String value){
    if (!kReleaseMode) {
      DevLog().defaultLogger.e('$tag: $value');
    }
  }

  static void wtf(String tag, String value){
    if (!kReleaseMode) {
      DevLog().defaultLogger.wtf('$tag: $value');
    }
  }

  static void oldDebug(String tag, String value){
    if (!kReleaseMode) {
      debugPrint('$tag: $value');
    }
  }

  static void oldError(String tag, String value){
    if (!kReleaseMode) {
      debugPrint('$tag: $value');
    }
  }
}