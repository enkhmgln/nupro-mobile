import 'package:get/get.dart';
import 'package:nuPro/library/library.dart';

class TermsOfServiceController extends IOController {
  var toc = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getToc();
  }

  void getToc() async {
    isLoading.value = true;

    final html = await InfoApi().getTermsOfService();

    isLoading.value = false;

    if (html != null && html.isNotEmpty) {
      toc.value = html;
    } else {
      showError(text: 'Үйлчилгээний нөхцөл авч чадсангүй');
    }
  }
}
