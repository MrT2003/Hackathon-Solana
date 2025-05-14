import 'package:flutter/material.dart';
import 'package:flutter_solana/view/collection_screen.dart';
import 'package:flutter_solana/view/history_and_rank.dart';
import 'package:flutter_solana/view/home_screen.dart';
import 'package:flutter_solana/view/profile_screen.dart';
import 'package:flutter_solana/view/qr_code.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NavController extends GetxController {
  late PersistentTabController tabController;

  @override
  void onInit() {
    tabController = PersistentTabController(initialIndex: 0);
    super.onInit();
  }

  final screens = [
    const HomeScreen(userName: 'Sugar Daddies'),
    const CollectionScreen(),
    const QrCode(),
    const HistoryAndRank(),
    const ProfileScreen(),
  ];

  final navBarsItems = [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: ("Home"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search),
      title: ("Collection"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(
        Icons.qr_code,
        color: Colors.white,
      ),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.star),
      title: ("History & Rank"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person),
      title: ("Profile"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}
