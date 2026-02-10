import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nuPro/library/extensions/extensions.dart';

extension ExtendedString on String {
  DateTime get toDate {
    return DateTime.tryParse(this) ?? DateTime.now();
  }

  DateTime toDateWithFormat({String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).parse(this);
  }

  String toFormattedString({String format = 'yyyy-MM-dd HH:mm'}) {
    return toDate.toFormattedString(format: format);
  }

  Color toHexColor() {
    String hexColor = toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    } else {
      hexColor = "FF000000";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
