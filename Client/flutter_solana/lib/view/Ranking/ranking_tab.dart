import 'package:flutter/material.dart';
import 'package:flutter_solana/controller/history_and_rank_controller.dart';
import 'package:get/get.dart';

class RankingTab extends StatelessWidget {
  RankingTab({Key? key}) : super(key: key);

  final HistoryAndRankController dateController =
      Get.put(HistoryAndRankController());

  final rankings = List.generate(
    5,
    (index) => {
      'rank': index + 1,
      'name': 'Name ${index + 1}',
      'university': 'University name',
      'score': 2000 - index * 100,
    },
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dateController.selectedDate.value = picked;
                  }
                },
                child: Obx(() {
                  final date = dateController.selectedDate.value;
                  return Text(date != null
                      ? '${date.year}-${date.month}-${date.day}'
                      : 'Select Date');
                }),
              ),
              DropdownButton<String>(
                value: 'University',
                items: const [
                  DropdownMenuItem(
                      value: 'University', child: Text('University')),
                ],
                onChanged: null,
              ),
            ],
          ),
        ),
        const Text(
          'Community',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Expanded(
          child: Container(
            color: const Color(0xFFFFF3EE),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              itemCount: rankings.length,
              itemBuilder: (context, index) {
                final item = rankings[index];
                return Container(
                  margin:
                      const EdgeInsets.only(bottom: 12, right: 20, left: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${item['rank']}',
                        style: TextStyle(
                          fontSize: 20,
                          color: index < 3 ? Colors.orange : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name']?.toString() ?? '',
                                style: const TextStyle(fontSize: 16)),
                            Text(item['university']?.toString() ?? '',
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text('${item['score']}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
