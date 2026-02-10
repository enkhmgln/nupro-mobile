import 'package:intl/intl.dart';

extension ExtendedDate on DateTime {
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  String toFormattedString({required String format}) {
    return DateFormat(format).format(toLocal());
  }
}
