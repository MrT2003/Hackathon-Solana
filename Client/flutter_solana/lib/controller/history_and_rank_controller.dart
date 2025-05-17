import 'package:get/get.dart';

class HistoryAndRankController extends GetxController {
  var isRankingSelected = true.obs;
  var selectedDate = Rxn<DateTime>();

  void toggleTab(bool value) {
    isRankingSelected.value = value;
  }
}
