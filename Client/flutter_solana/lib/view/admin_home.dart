import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'scanner_screen.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Mở máy quét QR'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 18),
          ),
          onPressed: () {
            // Điều hướng dùng GetX
            Get.to(() => const ScannerScreen());
          },
        ),
      ),
    );
  }
}
