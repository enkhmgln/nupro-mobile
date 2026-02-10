import 'package:get/get.dart';
import 'package:nuPro/library/client/api/user_api.dart';
import 'package:nuPro/library/client/models/user_model.dart';
import 'package:nuPro/library/pages/io_pages.dart';
import 'package:nuPro/library/shared/store_manager.dart';
import 'package:nuPro/library/utils/constants.dart';

class SessionManager {
  static final shared = SessionManager();

  Future getUser() async {
    final response = await UserApi().userInfo();
    if (response.isSuccess) {
      final user = UserModel.fromJson(response.data);
      await UserStoreManager.shared.write(kUser, user.toMap());
    }
  }

  Future logout() async {
    await UserStoreManager.shared.deleteStore();
    Get.offAllNamed(IOPages.initial);
  }
}
