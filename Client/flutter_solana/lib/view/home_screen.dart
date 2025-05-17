import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import 'homeScreen_components/wallet_card.dart';
import 'homeScreen_components/banner.dart';
import 'homeScreen_components/searchBar_filter.dart';
import 'homeScreen_components/product_card.dart';

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
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Voucher logic
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Image.asset('assets/icons/voucher.png',
                                    width: 20, height: 20),
                                const SizedBox(width: 6),
                                const Text('Voucher',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Rewarding',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),

                    // 🟢 Product grid
                    Obx(() {
                      final filteredProducts = c.searchQuery.value.isEmpty
                          ? c.products
                          : c.products
                              .where((p) => p['name']!
                                  .toLowerCase()
                                  .contains(c.searchQuery.value.toLowerCase()))
                              .toList();

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 150 / 200,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              // Product tap logic
                            },
                            child: ProductCard(
                              imageUrl: product['imageUrl']!,
                              name: product['name']!,
                              price: product['price']!,
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
