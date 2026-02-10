import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class Log {
  static success(String text, String name) {
    if (kDebugMode) {
      developer.log('\x1B[32m$text\x1B[0m', name: name);
    }
  }

  static error(String text, String name) {
    if (kDebugMode) {
      developer.log('\x1B[31m$text\x1B[0m', name: name);
    }
  }

  static warning(String text, String name) {
    if (kDebugMode) {
      developer.log('\x1B[33m$text\x1B[0m', name: name);
    }
  }
}
