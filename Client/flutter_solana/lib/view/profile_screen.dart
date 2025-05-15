import 'package:flutter/material.dart';
import 'package:flutter_solana/view/Profile/profile_item.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            width: double.infinity,
            height: 220,
            decoration: const BoxDecoration(
              color: Color(0xFFE0FFFF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                const Positioned(
                  top: 90,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.cyanAccent,
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.settings),
                    iconSize: 28,
                    color: Colors.black,
                    onPressed: () {
                      Get.toNamed('/setting-screen');
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 55),

          const Text(
            'Sugar Daddies',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // Details Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Details',
                  style: TextStyle(
                    color: Color(0xFF00B14F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ProfileItem(
                    title: 'University', value: 'International University'),
                ProfileItem(title: 'City', value: 'Ho Chi Minh City'),
                ProfileItem(title: 'Day of Birth', value: '1/1/2000'),
                ProfileItem(title: 'Email', value: 'example@email.com'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
