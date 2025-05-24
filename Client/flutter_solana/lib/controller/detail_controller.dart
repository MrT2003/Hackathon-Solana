import 'package:get/get.dart';

class DetailController extends GetxController {
  // Observable product details
  final productName = ''.obs;
  final productDescription = ''.obs;
  final productImageUrl = ''.obs; // Or image path

  final availableQuantity = 0.obs; // Observable integer for available quantity

  final baseTokenCost = 0.obs; // Observable integer for token cost per item
  final quantity = 1.obs; // Observable integer for item quantity

  // Computed observable for total token amount
  RxInt get totalTokenAmount => (baseTokenCost.value * quantity.value).obs;

  // Method to load product details (you would call this when navigating to the screen)
  void loadProductDetails({
    required String name,
    required String description,
    required String imageUrl,
    required int tokens,
    required int availability,
  }) {
    productName.value = name;
    productDescription.value = description;
    productImageUrl.value = imageUrl;
    baseTokenCost.value = tokens; // Set the base cost
    availableQuantity.value = availability; // Set the available quantity
    quantity.value = 1; // Reset quantity when loading a new product
  }

  void incrementQuantity() {
    if (quantity.value < availableQuantity.value) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // You can add other methods here for handling the exchange logic, etc.
}
