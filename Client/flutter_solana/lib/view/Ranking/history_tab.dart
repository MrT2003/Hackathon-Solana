import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final history = List.generate(
        5,
        (index) => {
              'message': 'Congratulation, Name',
              'date': '20/4/2025',
              'tokens': 1000,
            });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['message']?.toString() ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(item['date']?.toString() ?? ''),
                  ],
                ),
                Text(
                  '+ ${item['tokens']} Tokens',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
