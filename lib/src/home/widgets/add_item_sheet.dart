import 'package:buynow/src/home/home_controller.dart';
import 'package:buynow/src/home/item.dart';
import 'package:buynow/src/home/widgets/new_product_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddItemSheet extends StatefulWidget {
  final HomeController controller;

  const AddItemSheet({super.key, required this.controller});

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _categoryCtrl = TextEditingController();
  final TextEditingController _infoCtrl = TextEditingController();

  String categoryLabel(ItemCategory c) => itemCategoryLabels[c] ?? c.name;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _infoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: widget.controller.products,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || _nameCtrl.text.isEmpty) {
                    return const SizedBox();
                  }

                  final suggestions = snapshot.data!.docs
                      .where((doc) {
                        final name = doc['name'] as String;
                        return name.toLowerCase().contains(
                          _nameCtrl.text.toLowerCase(),
                        );
                      })
                      .take(5);

                  if (suggestions.isEmpty) return const SizedBox();

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: suggestions.map((doc) {
                      return GestureDetector(
                        onTap: () {
                          widget.controller.addItemToList(
                            listId: widget.controller.model.activeListId!,
                            itemId: doc.id,
                            name: doc['name'],
                            category: doc['category'],
                            icon: doc['icon'],
                            additionalInfo: '',
                          );
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6F7F86),
                            borderRadius: BorderRadius.circular(24),
                            border: const Border(
                              bottom: BorderSide(
                                color: CupertinoColors.activeBlue,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Image(
                                  image: AssetImage(
                                    'assets/icons/white/${doc['icon']}',
                                  ),
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              Text(
                                doc['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),

              CupertinoTextField(
                controller: _nameCtrl,
                placeholder: 'Produktname',
                autofocus: true,
                onChanged: (value) => setState(() {}),
                onSubmitted: (_) async {
                  final name = _nameCtrl.text.trim();
                  if (name.isEmpty) return;

                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => NewProductDetailsPage(
                        name: name,
                        controller: widget.controller,
                      ),
                    ),
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 8),

              CupertinoButton(
                child: const Text('Abbrechen'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
