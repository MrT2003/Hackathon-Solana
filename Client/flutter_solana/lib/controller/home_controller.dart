import 'package:get/get.dart';

class HomeController extends GetxController {
  final banners = <String>[
    'https://via.placeholder.com/350x100.png?text=Banner+1',
    'https://via.placeholder.com/350x100.png?text=Banner+2',
    'https://via.placeholder.com/350x100.png?text=Banner+3',
  ].obs;
  final currentBanner = 0.obs;
  void changeBanner(int idx) => currentBanner.value = idx;

  final balance = 2000.obs;

  final products = <Map<String, String>>[
    {
      'imageUrl': 'https://via.placeholder.com/100x100.png',
      'name': 'Product 1',
      'price': '45,000',
    },
    {
      'imageUrl': 'https://via.placeholder.com/100x100.png',
      'name': 'Product 2',
      'price': '50,000',
    },
    {
      'imageUrl': 'https://via.placeholder.com/100x100.png',
      'name': 'Product 1',
      'price': '55,000',
    },
  ].obs;

  final searchQuery = ''.obs;
  void setSearchQuery(String q) => searchQuery.value = q;
}
