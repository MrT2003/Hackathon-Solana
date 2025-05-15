import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    return Obx(() {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: MediaQuery.of(context).size.width - 32,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ECO-TOKEN',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF00B050))),
                  SizedBox(height: 4),
                  Text('Wallet balance:',
                      style: TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
              Row(
                children: [
                  Image.asset('assets/icons/token.png', width: 20, height: 20),
                  const SizedBox(width: 4),
                  Text(
                    c.balance.value.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
