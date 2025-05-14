import 'package:flutter/material.dart';

class SearchBarWithFilter extends StatelessWidget {
  const SearchBarWithFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
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
              prefixIcon: GestureDetector(
                onTap: () {
                  // Thêm chức năng cho nút menu bên trái search bả
                },
                child: const Icon(Icons.menu, color: Color(0xFF333333)),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  // Thêm chức năng cho search bar
                },
                child: const Icon(Icons.search, color: Color(0xFF333333)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            // Thêm chức năng cho nút filter
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF00B050),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.filter_list, color: Colors.white, size: 28),
            padding: const EdgeInsets.all(10),
          ),
        ),
      ],
    );
  }
}
