import 'package:nuPro/library/components/textfield/io_textfield_model.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/library/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IOTextfieldWidget extends StatefulWidget {
  final IOTextfieldModel model;
  final Widget? suffix;
  final VoidCallback? onTap;
  const IOTextfieldWidget({
    super.key,
    required this.model,
    this.suffix,
    this.onTap,
  });

  @override
  State<IOTextfieldWidget> createState() => _IOTextfieldWidgetState();
}

class _IOTextfieldWidgetState extends State<IOTextfieldWidget> {
  final borderRadius = BorderRadius.circular(8);

  Widget get secureButton => SizedBox.square(
        dimension: 48,
        child: IconButton(
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius.copyWith(
                topLeft: const Radius.circular(0),
                bottomLeft: const Radius.circular(0),
              ),
            ),
          ),
          icon: SvgPicture.asset(
            widget.model.isSecure
                ? 'assets/icons/eye.off.svg'
                : 'assets/icons/eye.on.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              IOColors.textTertiary,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            setState(() {
              widget.model.isSecure = !widget.model.isSecure;
            });
          },
        ),
      );
  Widget? get suffix =>
      widget.model.keyboardType == TextInputType.visiblePassword
          ? secureButton
          : widget.suffix;

  @override
  void initState() {
    super.initState();
    widget.model.focusNode.addListener(() {
      if (mounted) setState(() {});
    });
    widget.model.status.addListener(() {
      if (mounted) setState(() {});
    });
    if (widget.model.validators != null) {
      Validator(validations: widget.model.validators ?? []).setValidation(
        controller: widget.model.controller,
        status: widget.model.status,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      style: IOStyles.body2Regular.copyWith(
        color: IOColors.textPrimary.withOpacity(
          widget.model.isEnabled ? 1 : 0.5,
        ),
      ),
      inputFormatters: widget.model.inputFormatters,
      textInputAction: TextInputAction.done,
      cursorColor: IOColors.textPrimary,
      enabled: widget.model.isEnabled,
      focusNode: widget.model.focusNode,
      controller: widget.model.controller,
      keyboardType: widget.model.keyboardType,
      obscureText: widget.model.isSecure,
      autofocus: widget.model.autofocus,
      autocorrect: false,
      enableSuggestions: false,
      maxLength: widget.model.maxLength,
      maxLines: widget.model.maxLine,
      readOnly: widget.model.readOnly,
      decoration: InputDecoration(
          enabledBorder: widget.model.hasBorder
              ? OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: const BorderSide(
                    width: 1,
                    color: IOColors.strokePrimary,
                  ),
                )
              : InputBorder.none,
          disabledBorder: widget.model.hasBorder
              ? OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: const BorderSide(
                    width: 1,
                    color: IOColors.strokePrimary,
                  ),
                )
              : InputBorder.none,
          focusedBorder: widget.model.hasBorder
              ? OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: const BorderSide(
                    width: 1,
                    color: IOColors.brand500,
                  ),
                )
              : InputBorder.none,
          errorBorder: widget.model.hasBorder
              ? OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: const BorderSide(
                    width: 1,
                    color: IOColors.errorPrimary,
                  ),
                )
              : InputBorder.none,
          focusedErrorBorder: widget.model.hasBorder
              ? OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: const BorderSide(
                    width: 1,
                    color: IOColors.errorPrimary,
                  ),
                )
              : InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: widget.model.isEnabled
              ? IOColors.backgroundPrimary
              : IOColors.backgroundQuarternary,
          hintStyle: IOStyles.body1Regular.copyWith(
            color: IOColors.brand200,
          ),
          errorText: widget.model.status.value.descriptionText,
          counterText: '',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: IOStyles.caption1Regular.copyWith(
            color: IOColors.textTertiary,
          ),
          label: Text(widget.model.label),
          labelStyle: IOStyles.body1Regular.copyWith(
            color: IOColors.textTertiary,
          ),
          helperStyle: const TextStyle(fontSize: 0),
          counterStyle: const TextStyle(fontSize: 0),
          suffixIcon: suffix,
          suffixIconConstraints: const BoxConstraints(
            maxWidth: 48,
            minWidth: 24,
            maxHeight: 48,
            minHeight: 48,
          )),
    );
  }
}
