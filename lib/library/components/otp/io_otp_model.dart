import 'package:flutter/material.dart';

class IOOtpModel {
  final int length;
  final double size;
  final bool isSecure;
  final bool isAutoFocus;
  final TextInputType keyboardType;
  final controller = TextEditingController();
  final focus = FocusNode();

  String get value => controller.text;
  bool get isValid => value.length == length;

  IOOtpModel({
    this.length = 6,
    this.size = 56,
    this.isSecure = false,
    this.isAutoFocus = true,
    this.keyboardType = TextInputType.number,
  });
}
