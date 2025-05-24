import 'package:flutter/material.dart';
import 'package:flutter_solana/controller/transfer_controller.dart';
import 'package:flutter_solana/view/SignIn/sign_in.dart';
import 'package:flutter_solana/view/SignUp/sign_up.dart';
import 'package:flutter_solana/view/bottom_nav_bar.dart';
import 'package:flutter_solana/view/confirm_transfer_screen.dart';
import 'package:flutter_solana/view/home_screen.dart';
import 'package:flutter_solana/view/setting_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(TransferController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ECO-TOKEN',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF00B14F)),
        useMaterial3: true,
      ),
      initialRoute: '/sign-in',
      getPages: [
        GetPage(name: '/bottom-nav-bar', page: () => const BottomNavBar()),
        GetPage(
            name: '/home-screen',
            page: () => const HomeScreen(userName: 'Sugar Daddies')),
        GetPage(name: '/sign-in', page: () => const SignIn()),
        GetPage(name: '/sign-up', page: () => SignUp()),
        GetPage(name: '/setting-screen', page: () => const SettingsScreen()),
        GetPage(name: '/confirm-transfer', page: () => ConfirmTransferScreen()),
      ],
    );
  }
}
