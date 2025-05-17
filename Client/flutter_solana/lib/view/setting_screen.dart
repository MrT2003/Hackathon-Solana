import 'package:flutter/material.dart';
import 'package:flutter_solana/view/Setting/setting_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: const [
            SettingsItem(title: 'Change name'),
            SizedBox(height: 12),
            SettingsItem(title: 'Change password'),
            SizedBox(height: 12),
            SettingsItem(title: 'About me'),
          ],
        ),
      ),
    );
  }
}
