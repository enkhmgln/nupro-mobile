import 'package:get/get.dart';
import 'package:nuPro/library/client/api/info_api.dart';
import 'package:nuPro/library/components/main/io_controller.dart';

class PrivayPolicyController extends IOController {
  var privacy = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getToc();
  }

  void getToc() async {
    isLoading.value = true;

    final html = await InfoApi().getPrivacyPolicy();

    isLoading.value = false;

    if (html != null && html.isNotEmpty) {
      privacy.value = html;
    } else {
      showError(text: 'Үйлчилгээний нөхцөл авч чадсангүй');
    }
  }
}
