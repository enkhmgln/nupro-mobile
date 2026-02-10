import 'package:nuPro/library/shared/helper_manager.dart';
import 'package:nuPro/library/utils/call_status_enum.dart';

class CallStatusManager {
  static String get pending => CallStatus.pending.value;
  static String get accepted => CallStatus.accepted.value;
  static String get rejected => CallStatus.rejected.value;
  static String get completed => CallStatus.completed.value;
  static String get cancelled => CallStatus.cancelled.value;

  static List<String> getAvailableStatusChanges(String currentStatus) {
    final userType = HelperManager.profileInfo.userType;

    if (userType == 'nurse') {
      return _getNurseAvailableStatuses(currentStatus);
    } else {
      return _getCustomerAvailableStatuses(currentStatus);
    }
  }

  static List<String> _getNurseAvailableStatuses(String currentStatus) {
    if (currentStatus == pending) {
      return [accepted, rejected]; // Зөвшөөрөх эсвэл татгалзах
    } else if (currentStatus == accepted) {
      return []; // Дуусгах
    } else if (currentStatus == rejected ||
        currentStatus == completed ||
        currentStatus == cancelled) {
      return []; // Бусад төлөвт өөрчлөх боломжгүй
    } else {
      return [];
    }
  }

  static List<String> _getCustomerAvailableStatuses(String currentStatus) {
    if (currentStatus == pending || currentStatus == accepted) {
      return [cancelled]; // Цуцлах өөрсдийн дуудлагыг
    } else if (currentStatus == rejected ||
        currentStatus == completed ||
        currentStatus == cancelled) {
      return []; // Бусад төлөвт өөрчлөх боломжгүй
    } else {
      return [];
    }
  }

  // Check if status change is allowed
  static bool canChangeStatus(String currentStatus, String newStatus) {
    final availableStatuses = getAvailableStatusChanges(currentStatus);
    return availableStatuses.contains(newStatus);
  }

  static bool canCompleteCall(String currentStatus) {
    final userType = HelperManager.profileInfo.userType;
    return userType == 'nurse' && currentStatus == accepted;
  }

  static String getStatusDisplayText(String status) {
    if (status == pending) {
      return 'Хүлээгдэж байна';
    } else if (status == accepted) {
      return 'Зөвшөөрөгдсөн';
    } else if (status == rejected) {
      return 'Татгалзсан';
    } else if (status == completed) {
      return 'Дууссан';
    } else if (status == cancelled) {
      return 'Цуцлагдсан';
    } else {
      return status;
    }
  }

  // Get action button text for status change
  static String getActionButtonText(String status) {
    if (status == accepted) {
      return 'Зөвшөөрөх';
    } else if (status == rejected) {
      return 'Татгалзах';
    } else if (status == completed) {
      return 'Дуусгах';
    } else if (status == cancelled) {
      return 'Цуцлах';
    } else {
      return status;
    }
  }

  // Get status change confirmation message
  static String getConfirmationMessage(String currentStatus, String newStatus) {
    final userType = HelperManager.profileInfo.userType;

    if (userType == 'nurse') {
      if (newStatus == accepted) {
        return 'Та энэ дуудлагыг зөвшөөрөх үү?';
      } else if (newStatus == rejected) {
        return 'Та энэ дуудлагыг татгалзах уу?';
      } else if (newStatus == completed) {
        return 'Та энэ дуудлагыг дуусгах уу?';
      } else {
        return 'Та энэ дуудлагыг ${getStatusDisplayText(newStatus)} уу?';
      }
    } else {
      if (newStatus == cancelled) {
        return 'Та энэ дуудлагыг цуцлах уу?';
      } else {
        return 'Та энэ дуудлагыг ${getStatusDisplayText(newStatus)} уу?';
      }
    }
  }
}
