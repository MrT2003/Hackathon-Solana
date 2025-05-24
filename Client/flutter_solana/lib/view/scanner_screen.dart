import 'package:flutter/material.dart';
import 'package:flutter_solana/controller/transfer_controller.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
              facing: CameraFacing.back,
            ),
            onDetect: (BarcodeCapture capture) {
              final String? code = capture.barcodes.first.rawValue;
              if (code != null) {
                Get.find<TransferController>().setRecipient(code);
                Get.offNamed('/confirm-transfer');
              }
            },
          ),
          // Overlay UI
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Nút quay lại
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () => Get.offAllNamed('/admin-home'),
                      ),
                      const Spacer(),
                      const Text(
                        'Scan QR Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // để cân đối với icon back
                    ],
                  ),
                ),
                const Spacer(),
                // Khung quét QR
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
