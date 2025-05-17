import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CollectionItem {
  final String imageUrl;
  final String name;
  final String date;
  final int tokens;
  final bool isValid;

  CollectionItem({
    required this.imageUrl,
    required this.name,
    required this.date,
    required this.tokens,
    required this.isValid,
  });
}

class CollectionController extends GetxController {
  // All items
  final items = <CollectionItem>[
    CollectionItem(
      imageUrl:
          'https://pos.nvncdn.com/b5a043-19330/ps/20220618_BgAPjTSKOMhjWQKzuZsUbFZm.jpg',
      name: 'Sneaker',
      date: '20/5/2025',
      tokens: -200,
      isValid: true,
    ),
    CollectionItem(
      imageUrl:
          'https://product.hstatic.net/200000017420/product/_24.12_0317_4ed04594c0ff409ca7b62994b5801e7b_master.jpg',
      name: 'Bag',
      date: '20/5/2025',
      tokens: -200,
      isValid: true,
    ),
    CollectionItem(
      imageUrl:
          'https://product.hstatic.net/200000588671/product/ao-so-mi-nam-bycotton-white-oxford-shirt_665cc78010674835abdb2f715bbc5758_master.jpg',
      name: 'Shirt',
      date: '20/5/2025',
      tokens: -200,
      isValid: false,
    ),
    CollectionItem(
      imageUrl:
          'https://www.firstlite.com/dw/image/v2/BHHW_PRD/on/demandware.static/-/Sites-meateater-master/default/dwfde9fe06/mens-308-pant/mens-308-pant_walnut2.jpg?sw=800&sh=800',
      name: 'Pant',
      date: '20/5/2025',
      tokens: -200,
      isValid: true,
    ),
  ].obs;

  var searchQuery = ''.obs;
  var filter = 'All'.obs;
  var sortBy = 'Newest'.obs;

  List<CollectionItem> get filteredItems {
    var filtered = items.where((item) {
      if (filter.value == 'Valid') return item.isValid;
      if (filter.value == 'Invalid') return !item.isValid;
      return true;
    }).toList();
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((item) =>
              item.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
    // Add sorting logic
    return filtered;
  }

  void setFilter(String value) {
    filter.value = value;
  }

  void setSearch(String value) {
    searchQuery.value = value;
  }

  void setSortBy(String value) {
    sortBy.value = value;
  }
}
