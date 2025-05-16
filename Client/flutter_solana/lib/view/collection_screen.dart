import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/collection_controller.dart';
import 'Collection/collection_item_card.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionController controller = Get.put(CollectionController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Collection',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: controller.setSearch,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/icons/search.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      hintText: 'Search your item',
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    final sortOptions = ['Newest', 'Oldest', 'A-Z', 'Z-A'];
                    final selected = await showDialog<String>(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: const Text('Sort by'),
                        children: sortOptions
                            .map((option) => SimpleDialogOption(
                                  onPressed: () =>
                                      Navigator.pop(context, option),
                                  child: Text(option),
                                ))
                            .toList(),
                      ),
                    );
                    if (selected != null) {
                      controller.setSortBy(selected);
                    }
                  },
                  child: Obx(() => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text('Sort by: ${controller.sortBy.value}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            const Icon(Icons.keyboard_arrow_down,
                                size: 16, color: Colors.grey),
                          ],
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _FilterButton(
                      label: 'All',
                      selected: controller.filter.value == 'All',
                      onTap: () => controller.setFilter('All'),
                    ),
                    const SizedBox(width: 24),
                    _FilterButton(
                      label: 'Valid',
                      selected: controller.filter.value == 'Valid',
                      onTap: () => controller.setFilter('Valid'),
                    ),
                    const SizedBox(width: 24),
                    _FilterButton(
                      label: 'Invalid',
                      selected: controller.filter.value == 'Invalid',
                      onTap: () => controller.setFilter('Invalid'),
                    ),
                  ],
                )),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final items = controller.filteredItems;
                if (items.isEmpty) {
                  return const Center(child: Text('No items found'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return CollectionItemCard(item: item);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF00B14F).withOpacity(0.08)
              : Colors.white,
          border: Border.all(color: const Color(0xFF000000)),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF00B14F) : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
