import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/client/api/call_api.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/button/io_button_widget.dart';
import 'package:nuPro/library/components/main/io_alert.dart';
import 'package:nuPro/library/theme/io_colors.dart';

class CompletionCodeWidget extends StatefulWidget {
  final int callId;
  final VoidCallback? onCallCompleted;

  const CompletionCodeWidget({
    super.key,
    required this.callId,
    this.onCallCompleted,
  });

  @override
  State<CompletionCodeWidget> createState() => _CompletionCodeWidgetState();
}

class _CompletionCodeWidgetState extends State<CompletionCodeWidget> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IOColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Дуудлагыг дуусгах',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: IOColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Хэрэглэгчээс авсан 6 оронтой дуусгах кодыг оруулна уу',
            style: TextStyle(
              fontSize: 14,
              color: IOColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              hintText: '123456',
              hintStyle: TextStyle(
                fontSize: 24,
                color: Colors.grey.shade400,
                letterSpacing: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: IOColors.brand500),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            maxLength: 6,
          ),
          const SizedBox(height: 16),
          IOButtonWidget(
            model: IOButtonModel(
              label: 'Дуудлагыг дуусгах',
              type: IOButtonType.primary,
              size: IOButtonSize.medium,
              isLoading: _isLoading,
            ),
            onPressed: _isLoading ? null : _completeCall,
          ),
        ],
      ),
    );
  }

  Future<void> _completeCall() async {
    final code = _codeController.text.trim();

    if (code.length != 6) {
      const IOAlert(
        type: IOAlertType.warning,
        titleText: 'Алдаа',
        bodyText: '6 оронтой код оруулна уу',
        acceptText: 'Хаах',
      ).show();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await CallApi().completeCall(
        callId: widget.callId,
        completionCode: code,
      );

      if (response.isSuccess) {
        // Show success message first
        IOAlert(
          type: IOAlertType.success,
          titleText: 'Амжилттай',
          bodyText: response.message,
          acceptText: 'Хаах',
        ).show();

        widget.onCallCompleted?.call();
        _codeController.clear();

        // Navigate back to home after showing message
        Get.until((route) => route.isFirst);
        // await Get.find<MainController>().getUserInfo();
      } else {
        IOAlert(
          type: IOAlertType.error,
          titleText: 'Алдаа',
          bodyText: response.message,
          acceptText: 'Хаах',
        ).show();
      }
    } catch (e) {
      // const IOAlert(
      //   type: IOAlertType.error,
      //   titleText: 'Алдаа',
      //   bodyText: 'Дуудлагыг дуусгах явцад алдаа гарлаа',
      //   acceptText: 'Хаах',
      // ).show();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
