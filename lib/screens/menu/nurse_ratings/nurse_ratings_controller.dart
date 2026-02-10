import 'package:get/get.dart';
import 'package:nuPro/library/library.dart';

class NurseRatingsController extends IOController {
  NurseRatingsController({required this.nurseId});

  final int nurseId;

  // State
  var ratings = <dynamic>[].obs;
  @override
  var isLoading = false.obs;
  var error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchRatings();
  }

  Future<void> fetchRatings() async {
    try {
      isLoading.value = true;
      error.value = null;
      final response = await InfoApi().getRatingsNurse(id: nurseId.toString());
      if (response.isSuccess) {
        final ratingsList = response.data['ratings'].listValue;
        ratings.value = ratingsList;
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
