import 'package:flutter/material.dart';
import 'package:nuPro/library/components/textfield/io_textfield_model.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_shadow.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/library/utils/validator.dart';

enum IOTextfieldStatus {
  normal,
  error,
}

class IOTextfieldStatusModel {
  IOTextfieldStatus type;
  String? descriptionText;

  bool get isValid {
    return type == IOTextfieldStatus.normal;
  }

  bool get hasText {
    return descriptionText != null;
  }

  IOTextfieldStatusModel({
    this.type = IOTextfieldStatus.normal,
    this.descriptionText,
  });
}

class IOTextFieldLongText extends StatefulWidget {
  final IOTextfieldModel model;
  final VoidCallback? onTap;

  const IOTextFieldLongText({
    super.key,
    required this.model,
    this.onTap,
  });

  @override
  State<IOTextFieldLongText> createState() => _IOTextfieldWidgetState();
}

class _IOTextfieldWidgetState extends State<IOTextFieldLongText> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.model.focusNode.addListener(() {
        if (mounted) setState(() {});
      });

      if (widget.model.validators != null) {
        Validator(validations: widget.model.validators ?? []).setValidation(
          controller: widget.model.controller,
          status: widget.model.status,
        );
        widget.model.status.addListener(() {
          if (mounted) setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.model.label,
          style: IOStyles.caption1SemiBold,
        ),
        const SizedBox(height: 12),
        Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            color: Colors.white,
            boxShadow: IOShadow.primary1,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: widget.model.controller,
              cursorHeight: 18,
              cursorColor: IOColors.infoPrimary,
              maxLines: null,
              readOnly: widget.model.readOnly,
              textInputAction: TextInputAction.newline,
              style: IOStyles.body1Bold,
              decoration: InputDecoration(
                hintText: widget.model.label,
                hintStyle: IOStyles.body1Bold.copyWith(
                  color: IOColors.textQuarternary,
                ),
                hintMaxLines: 2,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
