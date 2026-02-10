import 'package:nuPro/library/client/api/user_api.dart';
import 'package:nuPro/library/client/models/profile_model.dart';
import 'package:nuPro/library/pages/io_pages.dart';
import 'package:nuPro/library/shared/location_manager.dart';
import 'package:nuPro/library/shared/store_manager.dart';
import 'package:nuPro/library/utils/constants.dart';
import 'package:nuPro/main_config.dart';

class ClientManager {
  // static Future getUserInfo() async {
  // final response = await CustomerApi().getUserInfo();
  // if (response.success) {
  //   final user = UserModel.fromJson(response.data);
  //   await UserStoreManager.shared.write(kUser, user.toMap());
  // }
  // }

  static Future getUserInfo() async {
    final response = await UserApi().userInfo();
    if (response.isSuccess) {
      final profile = ProfileModel.fromJson(response.data);
      await UserStoreManager.shared.write(kProfileUser, profile.toMap());
      if (profile.userType == 'nurse') {
        await IOPages.toNurse();
      } else {
        await IOPages.toHome();
      }

      // After successful login, prompt nurse or customer users to enable
      // high-accuracy location (Google Play Services dialog) when available.
      if (profile.userType == 'nurse' || profile.userType == 'customer') {
        try {
          await LocationManager.shared.triggerLocationSettingsDialog();
        } catch (e) {
          print('Failed to trigger location settings dialog: $e');
        }
      }

      // Handle any pending messages after successful login (only if there are any)
      await _handlePendingMessagesAfterLogin();
    }
  }

  static Future _handlePendingMessagesAfterLogin() async {
    try {
      // Only handle pending messages if there are any
      if (MainConfig.pendingMessages.isNotEmpty) {
        print(
            '📩 Found ${MainConfig.pendingMessages.length} pending messages after login');
        MainConfig.handlePendingMessagesAfterLogin();
      } else {
        print('📩 No pending messages after login');
      }
    } catch (e) {
      print('Error handling pending messages after login: $e');
    }
  }

  static Future getNotificationCount() async {
    // final response = await CustomerApi().getNotificationCount();
    // if (response.success) {
    //   final count = response.json['notif_count'].integerValue;
    //   await UserStoreManager.shared.write(
    //     kNotificationCount,
    //     count,
    //   );
    // }
  }
}
