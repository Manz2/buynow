import 'package:buynow/src/home/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ItemList extends StatelessWidget {
  final HomeController controller;

  const ItemList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: controller.activeItems,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CupertinoActivityIndicator();
        }

        final items = snapshot.data!.docs;

        if (items.isEmpty) {
          return const Center(child: Text('Keine Items'));
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: items.map((item) {
            final completed = item['completed'] as bool;
            final data = item.data();
            final icon = data['icon'] as String? ?? 'default.png';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: completed
                    ? CupertinoColors.systemGrey5
                    : CupertinoColors.systemBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/white/$icon',
                      width: 48,
                      height: 48,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 20,
                          decoration: completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    if (item['additionalInfo'] != null &&
                        (item['additionalInfo'] as String).isNotEmpty)
                      Text(
                        item['additionalInfo'],
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
