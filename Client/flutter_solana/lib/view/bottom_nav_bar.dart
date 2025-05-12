import 'package:flutter/material.dart';
import 'package:flutter_solana/controller/nav_controller.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavController navController = Get.put(NavController());

    return PersistentTabView(
      context,
      controller: navController.tabController,
      screens: navController.screens,
      items: navController.navBarsItems,
      navBarStyle: NavBarStyle.style15, // hoặc style khác
      backgroundColor: Colors.white,
    );
  }
}
