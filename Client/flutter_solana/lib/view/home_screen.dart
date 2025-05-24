import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import 'homeScreen_components/wallet_card.dart';
import 'homeScreen_components/banner.dart';
import 'homeScreen_components/searchBar_filter.dart';
import 'homeScreen_components/product_card.dart';
import '../controller/detail_controller.dart';
import '../view/detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    // Register controller once when this screen is built
    final HomeController c = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF38C864),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Welcome back!',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                                const SizedBox(height: 2),
                                Text(userName,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  // Notification logic
                                },
                                child: const Icon(Icons.notifications,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const WalletCard(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: BannerCarousel(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SearchBarWithFilter(),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.10),
                        //     blurRadius: 12,
                        //     offset: const Offset(0, 6),
                        //   ),
                        // ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: Obx(
                        () => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: c.categories.map((category) {
                              final isSelected =
                                  c.selectedCategory.value == category;
                              return GestureDetector(
                                onTap: () =>
                                    c.selectedCategory.value = category,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Rewarding',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),

                    // 🟢 Product grid
                    Obx(() {
                      final filteredProducts = c.products
                          .where((p) =>
                              (c.searchQuery.value.isEmpty ||
                                  p['name']!.toLowerCase().contains(
                                      c.searchQuery.value.toLowerCase())) &&
                              p['category'] == c.selectedCategory.value)
                          .toList();

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 150 / 220,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              final DetailController detailController =
                                  Get.put(DetailController());
                              final int tokens = int.parse(
                                  product['price']!.replaceAll(',', ''));
                              final int availability =
                                  int.parse(product['availability']!);
                              detailController.loadProductDetails(
                                name: product['name']!,
                                description: product['description']!,
                                imageUrl: product['imageUrl']!,
                                tokens: tokens,
                                availability: availability,
                              );
                              Get.to(() => const DetailScreen());
                            },
                            child: ProductCard(
                              imageUrl: product['imageUrl']!,
                              name: product['name']!,
                              price: product['price']!,
                              availability: product['availability']!,
                            ),
                          );
                        },
                      );
                    }),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
