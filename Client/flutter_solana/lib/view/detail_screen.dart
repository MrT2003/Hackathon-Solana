import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_solana/controller/detail_controller.dart'; // Assuming you have a DetailController

class DetailScreen extends GetView<DetailController> {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Obx(() => Image.network(
                      controller.productImageUrl.value,
                      width: double.infinity,
                      height: 500,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 300,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.grey[600]),
                      ),
                    )),
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          controller.productName.value,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: 8),
                    const Text(
                      'Product Description',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          controller.productDescription.value,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, -2),
            ),
          ],
        ),
        // child: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     const Text(
        //       'Token',
        //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //     ),
        //     const SizedBox(height: 8),
        //     Row(
        //       children: [
        //         Icon(Icons.eco, color: Colors.green),
        //         const SizedBox(width: 8),
        //         Obx(() => Text(
        //               '${controller.totalTokenAmount.value}',
        //               style: TextStyle(
        //                   fontSize: 18,
        //                   color: Colors.green,
        //                   fontWeight: FontWeight.bold),
        //             )),
        //       ],
        //     ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: Token label (left) and Available (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Token',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Obx(() => Text(
                      'Available: ${controller.availableQuantity.value}',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    )),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.eco, color: Colors.green),
                const SizedBox(width: 8),
                Obx(() => Text(
                      '${controller.totalTokenAmount.value}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: controller.decrementQuantity,
                        ),
                        Obx(() => Text(
                              '${controller.quantity.value}',
                              style: TextStyle(fontSize: 18),
                            )),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: controller.incrementQuantity,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement exchange logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B14F),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Exchange',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
