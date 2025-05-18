import 'package:get/get.dart';

class TransferController extends GetxController {
  RxString recipientAddress = ''.obs;
  RxString amount = ''.obs;

  void setRecipient(String address) {
    recipientAddress.value = address;
  }

  void setAmount(String value) {
    amount.value = value;
  }

  void clearAll() {
    recipientAddress.value = '';
    amount.value = '';
  }
}
