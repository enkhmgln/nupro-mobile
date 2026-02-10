import 'package:nuPro/library/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IOTextfieldModel {
  final String label;
  final TextInputType keyboardType;
  final List<ValidatorType>? validators;
  final List<TextInputFormatter>? inputFormatters;

  bool isSecure = false;
  bool isEnabled = true;
  bool readOnly = false;
  bool hasBorder = true;
  bool autofocus = false;
  int? maxLength;
  int maxLine = 1;

  IOTextfieldModel({
    required this.label,
    this.keyboardType = TextInputType.text,
    this.isSecure = false,
    this.isEnabled = true,
    this.readOnly = false,
    this.hasBorder = true,
    this.autofocus = false,
    this.validators,
    this.inputFormatters,
    this.maxLength,
    this.maxLine = 1,
  });

  final focusNode = FocusNode();
  final controller = TextEditingController();
  final status = ValueNotifier(IOTextfieldStatusModel());

  String get value => controller.text;
  bool get isValid => status.value.isValid;

  void setData(String text) {
    controller.text = text;

    if (validators == null) {
      status.value = IOTextfieldStatusModel(
        status: IOTextfieldStatus.success,
      );
    } else {
      final valid = Validator(validations: validators!).isValid(text);
      status.value = IOTextfieldStatusModel(
        status: valid.$1 ? IOTextfieldStatus.success : IOTextfieldStatus.normal,
      );
    }
  }
}

class IOTextfieldStatusModel {
  IOTextfieldStatus status;
  String? descriptionText;

  bool get isValid {
    return status == IOTextfieldStatus.success;
  }

  bool get hasText {
    return descriptionText != null;
  }

  IOTextfieldStatusModel({
    this.status = IOTextfieldStatus.normal,
    this.descriptionText,
  });
}

enum IOTextfieldStatus {
  normal,
  error,
  success,
}
