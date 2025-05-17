import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';

class SearchBarWithFilter extends StatelessWidget {
  const SearchBarWithFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: c.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search here',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide:
                    const BorderSide(color: Color(0xFF00B050), width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide:
                    const BorderSide(color: Color(0xFF00B050), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide:
                    const BorderSide(color: Color(0xFF00B050), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.menu, color: Color(0xFF333333)),
              suffixIcon: const Icon(Icons.search, color: Color(0xFF333333)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF00B050),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.filter_list, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }
}
