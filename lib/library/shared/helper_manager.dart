import 'package:nuPro/library/client/models/profile_model.dart';
import 'package:nuPro/library/client/models/token_model.dart';
import 'package:nuPro/library/client/models/user_model.dart';
import 'package:nuPro/library/shared/store_manager.dart';
import 'package:nuPro/library/utils/constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HelperManager {
  static bool get isOnboardingCompleted =>
      DeviceStoreManager.shared.data<bool>(kOnboardingCompleted) ?? false;
  static bool get isLogged => UserStoreManager.shared.hasData(kToken);

  static String get fcmToken {
    return DeviceStoreManager.shared.data<String>(kFcmToken) ?? '';
  }

  static TokenModel get token {
    final json = UserStoreManager.shared.jsonData(kToken);
    return TokenModel.fromJson(json);
  }

  static UserModel get user {
    final json = UserStoreManager.shared.jsonData(kUser);
    return UserModel.fromJson(json);
  }

  static ProfileModel get profileInfo {
    final json = UserStoreManager.shared.jsonData(kProfileUser);
    return ProfileModel.fromJson(json);
  }

  static String get os {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      _ => '',
    };
  }

  static Future<String> get deviceModel async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => (await deviceInfoPlugin.androidInfo).device,
      TargetPlatform.iOS => (await deviceInfoPlugin.iosInfo).model,
      _ => '',
    };
  }

  static Future<String> get deviceId async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => (await deviceInfoPlugin.androidInfo).id,
      TargetPlatform.iOS =>
        (await deviceInfoPlugin.iosInfo).identifierForVendor ?? 'EMPTYID',
      _ => '',
    };
  }

  static Future<String> get version async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> get appVersion async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String build = packageInfo.buildNumber;
    return '$version-$build';
  }
}
