import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/client/api/call_api.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/button/io_button_widget.dart';
import 'package:nuPro/library/components/main/io_alert.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/utils/call_status_manager.dart';

class CallStatusWidget extends StatelessWidget {
  final String currentStatus;
  final int callId;
  final VoidCallback? onStatusChanged;

  const CallStatusWidget({
    super.key,
    required this.currentStatus,
    required this.callId,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final availableStatuses =
        CallStatusManager.getAvailableStatusChanges(currentStatus);

    if (availableStatuses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: IOColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: IOColors.brand100, width: 1),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: IOColors.brand50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              CallStatusManager.getStatusDisplayText(currentStatus),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: IOColors.brand500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Action buttons
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: availableStatuses.map((status) {
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: IOButtonWidget(
                    model: IOButtonModel(
                      label: CallStatusManager.getActionButtonText(status),
                      type: _getButtonType(status),
                      size: IOButtonSize.small,
                    ),
                    onPressed: () => _showConfirmationDialog(status),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IOButtonType _getButtonType(String status) {
    if (status == CallStatusManager.accepted) {
      return IOButtonType.primary;
    } else if (status == CallStatusManager.rejected) {
      return IOButtonType.secondary;
    } else if (status == CallStatusManager.completed) {
      return IOButtonType.primary;
    } else if (status == CallStatusManager.cancelled) {
      return IOButtonType.secondary;
    } else {
      return IOButtonType.primary;
    }
  }

  void _showConfirmationDialog(String newStatus) {
    final message =
        CallStatusManager.getConfirmationMessage(currentStatus, newStatus);

    IOAlert(
      type: IOAlertType.warning,
      titleText: 'Баталгаажуулах',
      bodyText: message,
      acceptText: 'Тийм',
      cancelText: 'Үгүй',
    ).show().then((result) {
      if (result == true) {
        _updateCallStatus(newStatus);
      }
    });
  }

  Future<void> _updateCallStatus(String newStatus) async {
    try {
      final response = await CallApi().updateCallStatus(
        callId: callId,
        status: newStatus,
      );

      if (response.isSuccess) {
        Get.back(); // Close any open dialogs
        IOAlert(
          type: IOAlertType.success,
          titleText: 'Амжилттай',
          bodyText: response.message,
          acceptText: 'Хаах',
        ).show();
        onStatusChanged?.call();
      } else {
        IOAlert(
          type: IOAlertType.error,
          titleText: 'Алдаа',
          bodyText: response.message,
          acceptText: 'Хаах',
        ).show();
      }
    } catch (e) {
      const IOAlert(
        type: IOAlertType.error,
        titleText: 'Алдаа',
        bodyText: 'Дуудлагын төлөв өөрчлөхөд алдаа гарлаа',
        acceptText: 'Хаах',
      ).show();
    }
  }
}
