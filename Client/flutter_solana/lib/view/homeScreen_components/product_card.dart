import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  const ProductCard(
      {required this.imageUrl,
      required this.name,
      required this.price,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 230,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey, size: 40),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Row(
            children: [
              Image.asset('assets/icons/token.png', width: 18, height: 18),
              const SizedBox(width: 2),
              Text(price,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF00B050))),
            ],
          ),
        ],
      ),
    );
  }
}
