import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatelessWidget {
  final String uid;
  final String name;

  const QrCodeScreen({
    super.key,
    required this.uid,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = jsonEncode({'uid': uid, 'name': name});

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.green.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quét mã để truy cập:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: QrImageView(
                data: qrData, // dùng dữ liệu có uid và name
                version: QrVersions.auto,
                size: 200.0,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              qrData.replaceAll('\n', ' | '),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
