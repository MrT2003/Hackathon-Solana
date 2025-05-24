import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    return Obx(() {
      return Column(
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: PageController(
                viewportFraction: 1,
                initialPage: c.currentBanner.value,
              ),
              itemCount: c.banners.length,
              onPageChanged: c.changeBanner,
              itemBuilder: (_, idx) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(c.banners[idx]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              c.banners.length,
              (idx) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.currentBanner.value == idx
                      ? Colors.grey[700]
                      : Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
