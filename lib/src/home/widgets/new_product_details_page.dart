import 'package:buynow/src/home/home_controller.dart';
import 'package:buynow/src/home/item.dart';
import 'package:flutter/cupertino.dart';

class NewProductDetailsPage extends StatefulWidget {
  final String name;
  final HomeController controller;

  const NewProductDetailsPage({
    super.key,
    required this.name,
    required this.controller,
  });

  @override
  State<NewProductDetailsPage> createState() => _NewProductDetailsPageState();
}

class _NewProductDetailsPageState extends State<NewProductDetailsPage> {
  ItemCategory? _selectedCategory;
  String? _selectedIcon;
  late final TextEditingController _nameCtrl;
  late final FocusNode _nameFocus;

  String categoryLabel(ItemCategory c) => itemCategoryLabels[c] ?? c.name;

  final _icons = ['paprika.png', 'milk.png', 'flour.png', 'default.png'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _nameFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _selectedCategory != null && _selectedIcon != null;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Neues Produkt'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: canSave ? _save : null,
          child: const Text('Hinzufügen'),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Section(
              title: 'Produkt',
              child: CupertinoTextField(
                controller: _nameCtrl,
                focusNode: _nameFocus,
                placeholder: 'Produktname',
                onChanged: (value) => setState(() {}),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Kategorie
            _Section(
              title: 'Kategorie',
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  _nameFocus.unfocus();
                  showCupertinoModalPopup(
                    context: context,
                    builder: (_) => CupertinoActionSheet(
                      title: const Text('Kategorie auswählen'),
                      actions: ItemCategory.values.map((category) {
                        return CupertinoActionSheetAction(
                          onPressed: () {
                            setState(() => _selectedCategory = category);
                            Navigator.pop(context);
                          },
                          child: Text(categoryLabel(category)),
                        );
                      }).toList(),
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Abbrechen'),
                      ),
                    ),
                  );
                },
                child: CupertinoTextField(
                  enabled: false,
                  placeholder: 'Auswählen',
                  controller: TextEditingController(
                    text: _selectedCategory == null
                        ? ''
                        : categoryLabel(_selectedCategory!),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Icon-Auswahl
            _Section(
              title: 'Icon',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _icons.map((icon) {
                  final selected = _selectedIcon == icon;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected
                            ? CupertinoColors.activeBlue
                            : const Color(0xFF6F7F86),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/icons/white/$icon',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    widget.controller.addItemToProducts(
      listId: widget.controller.model.activeListId!,
      name: widget.name,
      category: _selectedCategory!.name,
      icon: _selectedIcon!,
    );

    Navigator.pop(context);
  }
}

/// 🔹 Wiederverwendbare Sektion (optisch ruhig)
class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            color: CupertinoColors.systemGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
