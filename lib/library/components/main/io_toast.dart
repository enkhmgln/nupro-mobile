import 'package:nuPro/library/theme/io_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IOToast {
  final String text;
  final Color? backgroundColor;
  final ToastGravity? gravity;
  final int? time;

  IOToast({
    required this.text,
    this.backgroundColor,
    this.gravity,
    this.time,
  });

  void show() {
    print('IOToast: Attempting to show toast with text: $text');
    try {
      Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: time ?? 1,
        backgroundColor: backgroundColor ?? IOColors.brand400,
        textColor: IOColors.backgroundPrimary,
        fontSize: 16,
      );
      print('IOToast: Toast show() called successfully');
    } catch (e) {
      print('IOToast: Error showing toast: $e');
    }
  }
}
