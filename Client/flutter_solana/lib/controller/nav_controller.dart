import 'package:flutter/material.dart';
import 'package:flutter_solana/controller/auth_controller.dart';
import 'package:flutter_solana/view/collection_screen.dart';
import 'package:flutter_solana/view/history_and_rank.dart';
import 'package:flutter_solana/view/home_screen.dart';
import 'package:flutter_solana/view/profile_screen.dart';
import 'package:flutter_solana/view/qr_code_screen.dart';
import 'package:flutter_solana/view/scanner_screen.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NavController extends GetxController {
  late PersistentTabController tabController;
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    tabController = PersistentTabController(initialIndex: 0);
    super.onInit();
  }

  List<Widget> get screens {
    final user = authController.currentUser.value;
    return [
      HomeScreen(userName: user?.name ?? 'Guest'),
      const CollectionScreen(),
      QrCodeScreen(
        uid: user?.uid ?? '',
        name: user?.name ?? '',
        publicKey: user?.walletPublicKey ?? '',
      ),
      const HistoryAndRank(),
      const ProfileScreen(),
    ];
  }

  final navBarsItems = [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home, size: 30),
      title: ("Home"),
      activeColorPrimary: Color(0xFF00B14F),
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search, size: 30),
      title: ("Collection"),
      activeColorPrimary: Color(0xFF00B14F),
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.qr_code, color: Colors.white),
      activeColorPrimary: Color(0xFF00B14F),
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.star, size: 30),
      title: ("History & Rank"),
      activeColorPrimary: Color(0xFF00B14F),
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person, size: 30),
      title: ("Profile"),
      activeColorPrimary: Color(0xFF00B14F),
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}
