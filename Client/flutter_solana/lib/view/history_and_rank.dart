import 'package:flutter/material.dart';
import 'package:flutter_solana/controller/history_and_rank_controller.dart';
import 'package:flutter_solana/view/Ranking/history_tab.dart';
import 'package:flutter_solana/view/Ranking/ranking_tab.dart';
import 'package:get/get.dart';

class HistoryAndRank extends StatelessWidget {
  const HistoryAndRank({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryAndRankController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => controller.toggleTab(true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.isRankingSelected.value
                              ? Color(0xFF00B14F)
                              : Colors.transparent,
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Text(
                          'Ranking',
                          style: TextStyle(
                            color: controller.isRankingSelected.value
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.toggleTab(false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !controller.isRankingSelected.value
                              ? Color(0xFF00B14F)
                              : Colors.transparent,
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Text(
                          'History',
                          style: TextStyle(
                            color: !controller.isRankingSelected.value
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() => controller.isRankingSelected.value
                  ? RankingTab()
                  : HistoryTab()),
            ),
          ],
        ),
      ),
    );
  }
}
