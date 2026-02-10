import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuPro/library/client/api/call_api.dart';
import 'package:nuPro/library/client/models/completion_code_model.dart';
import 'package:nuPro/library/components/main/io_alert.dart';
import 'package:nuPro/library/theme/io_colors.dart';

class CompletionCodeDisplayWidget extends StatefulWidget {
  final int callId;

  const CompletionCodeDisplayWidget({
    super.key,
    required this.callId,
  });

  @override
  State<CompletionCodeDisplayWidget> createState() =>
      _CompletionCodeDisplayWidgetState();
}

class _CompletionCodeDisplayWidgetState
    extends State<CompletionCodeDisplayWidget> {
  CompletionCodeModel? _completionCode;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchCompletionCode();
  }

  Future<void> _fetchCompletionCode() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      final response = await CallApi().getCompletionCode(
        callId: widget.callId,
      );

      if (response.isSuccess) {
        setState(() {
          _completionCode = CompletionCodeModel.fromJson(response.data);
          _hasError = false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: IOColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_hasError || _completionCode == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Код татаж чадсангүй',
                style: TextStyle(fontSize: 13, color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: _fetchCompletionCode,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Дахин', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: IOColors.brand50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: IOColors.brand200),
      ),
      child: Row(
        children: [
          // Icon
          const Icon(Icons.security, color: IOColors.brand500, size: 20),
          const SizedBox(width: 10),

          // Code display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Дуусгах код',
                  style: TextStyle(
                    fontSize: 11,
                    color: IOColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: _completionCode!.completionCode));
                    const IOAlert(
                      type: IOAlertType.success,
                      titleText: 'Амжилттай',
                      bodyText: 'Код хуулагдлаа',
                      acceptText: 'Хаах',
                    ).show();
                  },
                  child: Text(
                    _completionCode!.completionCode,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: IOColors.brand500,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Copy button and expiry
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: _completionCode!.completionCode));
                  const IOAlert(
                    type: IOAlertType.success,
                    titleText: 'Амжилттай',
                    bodyText: 'Код хуулагдлаа',
                    acceptText: 'Хаах',
                  ).show();
                },
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: IOColors.brand500,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.copy,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatExpiryTimeShort(_completionCode!.expiresAt),
                style: const TextStyle(
                  fontSize: 10,
                  color: IOColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatExpiryTimeShort(String expiresAt) {
    try {
      final dateTime = DateTime.parse(expiresAt);
      final now = DateTime.now();
      final difference = dateTime.difference(now);

      if (difference.isNegative) {
        return 'Дууссан';
      }

      final minutes = difference.inMinutes;
      final hours = difference.inHours;

      if (hours > 0) {
        return '$hoursц ${minutes % 60}м';
      } else {
        return '$minutesм';
      }
    } catch (e) {
      return 'Тодорхойгүй';
    }
  }
}
