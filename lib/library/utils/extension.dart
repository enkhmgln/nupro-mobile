import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ExtendedDate on DateTime {
  String toFormattedString(String format) {
    return DateFormat(format).format(this);
  }
}

extension ExtendedString on String {
  DateTime get toDate {
    return DateTime.tryParse(this) ?? DateTime.now();
  }

  DateTime toFormattedDate({String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).parse(this);
  }

  String toFormattedDefault(String format) {
    return toDate.toFormattedString(format);
  }

  String toFormattedString({String format = 'yyyy-MM-dd'}) {
    return toDate.toFormattedString(format);
  }

  int toInt() {
    try {
      String cleanedString = replaceAll(',', '');
      return int.parse(cleanedString);
    } catch (e) {
      return 0;
    }
  }
}

extension ExtendedDouble on double {
  String toFormattedPoint() {
    final format = NumberFormat.currency(
      decimalDigits: 0,
      customPattern: '###,###,###,###,###',
    );
    return format.format(this);
  }

  String toCurrency({String? locale}) {
    var formatSymbol = NumberFormat.simpleCurrency(locale: locale ?? 'mn');
    final format = NumberFormat.currency(
      decimalDigits: 0,
      customPattern: '###,###,###,###,###${formatSymbol.currencySymbol}',
    );
    return format.format(this);
  }

  bool get isInteger => this == toInt();
}

extension ExtendedText on Text {
  RichText toCurrency() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: data!,
            style: style,
          ),
          WidgetSpan(
            child: Transform.translate(
              offset: const Offset(-1, -12),
              child: Image.asset(
                'assets/images/tugrik.png',
                color: style?.color,
                height: (style?.fontSize)! / 2,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
