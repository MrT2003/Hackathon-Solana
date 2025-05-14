import 'package:flutter/material.dart';
import 'homeScreen_components/wallet_card.dart';
import 'homeScreen_components/banner.dart';
import 'homeScreen_components/searchBar_filter.dart';
import 'homeScreen_components/product_card.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;
  final PageController _bannerController = PageController();

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // data mẫu cho product card
    final List<Map<String, String>> products = [
      {
        'imageUrl': 'https://via.placeholder.com/100x100.png',
        'name': 'Product 1',
        'price': '45,000',
      },
      {
        'imageUrl': 'https://via.placeholder.com/100x100.png',
        'name': 'product 2',
        'price': '45,000',
      },
      {
        'imageUrl': 'https://via.placeholder.com/100x100.png',
        'name': 'Product 3',
        'price': '50,000',
      },
      {
        'imageUrl': 'https://via.placeholder.com/100x100.png',
        'name': 'Product 4',
        'price': '60,000',
      },
    ];

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
                                Text(widget.userName,
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
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  // thêm chức năng cho chuông thông báo
                                },
                                child: const Icon(Icons.notifications, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const WalletCard(balance: 2000),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: BannerCarousel(
                  banners: const [
                    'https://via.placeholder.com/350x100.png?text=Banner+1',
                    'https://via.placeholder.com/350x100.png?text=Banner+2',
                    'https://via.placeholder.com/350x100.png?text=Banner+3',
                  ],
                ),
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
                            // Thêm chức năng cho nút voucher
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 12,
                                  offset: const Offset(
                                      0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Image.asset('assets/icons/voucher.png', width: 20, height: 20),
                                SizedBox(width: 6),
                                Text('Voucher',
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
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 150 / 190,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            // Thêm chức năng cho product card
                          },
                          child: ProductCard(
                            imageUrl: product['imageUrl']!,
                            name: product['name']!,
                            price: product['price']!,
                          ),
                        );
                      },
                    ),
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
