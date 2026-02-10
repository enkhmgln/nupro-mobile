import 'package:get/get.dart';
import 'package:nuPro/library/library.dart';

class MyRatingsController extends IOController {
  @override
  var isLoading = true.obs;
  var error = RxnString();
  var ratings = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRatings();
  }

  Future<void> fetchRatings() async {
    isLoading.value = true;
    error.value = null;
    try {
      final response = await InfoApi().getMyRatings();
      if (response.isSuccess) {
        ratings.value = response.data.listValue;
      } else {
        error.value = response.message;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
