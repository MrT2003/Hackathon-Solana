import 'package:flutter/material.dart';
import 'package:flutter_solana/controller/counter_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CounterController controller = Get.put(CounterController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX Counter'),
      ),
      body: Center(
        child: Obx(() => Text(
              'Count: ${controller.count}',
              style: const TextStyle(fontSize: 32),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
