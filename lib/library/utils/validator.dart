import 'package:nuPro/library/components/textfield/io_textfield_model.dart';
import 'package:flutter/material.dart';

enum ValidatorType {
  notEmpty(errorText: 'Утга оруулна уу'),
  amount(errorText: 'Мөнгөн дүн буруу'),
  decimal(errorText: 'Утга буруу'),
  phone(errorText: 'Зөв дугаар оруулна уу'),
  email(errorText: 'И-мэйл хаяг буруу'),
  age(errorText: 'Насны утга буруу'),
  registerNumber(errorText: 'Регистрийн дугаар буруу'),
  cyrillic(errorText: 'Кирил тэмдэгт биш байна'),
  pin(errorText: '4 оронтой тоо оруулна уу'),
  noSpecialChar(errorText: 'Тусгай тэмдэгт агуулсан байна'),
  password(errorText: 'Нууц үг буруу');

  const ValidatorType({required this.errorText});
  final String errorText;
}

class Validator {
  final List<ValidatorType> validations;
  Validator({required this.validations});

  (bool, String?) isValid(String text) {
    for (final validation in validations) {
      if (_isValid(validation, text) == false) {
        return (false, validation.errorText);
      }
    }
    return (true, null);
  }

  bool _isValid(ValidatorType type, String text) {
    String pattern;

    switch (type) {
      case ValidatorType.notEmpty:
        pattern = r'^(?!\s*$).+';
        break;
      case ValidatorType.amount:
        pattern = r'^[1-9][0-9]*$';
        break;
      case ValidatorType.decimal:
        pattern = r'^[0-9]*\.?[0-9]+$';
        break;

      case ValidatorType.phone:
        pattern = r'^[6-9]{1}[0-9]{7}$';
        break;
      case ValidatorType.age:
        pattern = r'^[0-9]{1,3}$';
        break;
      case ValidatorType.email:
        pattern =
            r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]{2,50}@[a-zA-Z0-9._-]+(?!.*\\.\\.)\.[a-zA-Z]{2,64}";
        break;
      case ValidatorType.registerNumber:
        pattern =
            r'^[0-9]{2}(1[0-2]|0[1-9]|2[1-9]|3[0-2])(0[1-9]|[1-2][0-9]|3[0-1])[0-9]{2}$';
        break;
      case ValidatorType.cyrillic:
        pattern = r'^[а-яА-ЯөүӨҮёЁ-]{1,50}$';
        break;
      case ValidatorType.pin:
        pattern = r'^[0-9]{4}$';
        break;

      case ValidatorType.noSpecialChar:
        pattern = r'^[^!<>|&]+$';
        break;

      case ValidatorType.password:
        // pattern = r'[A-Z]{1}[a-z]{1}[0-9]{6}';
        pattern = r'^.{6,}$';
        break;
    }
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(text);
  }

  setValidation({
    required TextEditingController controller,
    required ValueNotifier<IOTextfieldStatusModel> status,
  }) {
    controller.addListener(() {
      final valid = isValid(controller.text);
      status.value = IOTextfieldStatusModel(
        status: valid.$1 ? IOTextfieldStatus.success : IOTextfieldStatus.error,
        descriptionText: valid.$2,
      );
    });
  }
}
