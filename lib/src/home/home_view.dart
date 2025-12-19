import 'package:buynow/src/home/widgets/add_item_sheet.dart';
import 'package:buynow/src/home/widgets/item_list.dart';
import 'package:buynow/src/home/widgets/list_selector_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = HomeController();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          controller.model.activeListName ?? 'Keine Liste (icons by Icons8)',
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.list_bullet),
          onPressed: () => showListSelectorSheet(
            context: context,
            controller: controller,
            onChanged: () => setState(() {}),
          ),
        ),
      ),
      child: SafeArea(
        child: controller.activeItems == null
            ? const Center(child: Text('Bitte Liste auswählen'))
            : Stack(
                children: [
                  Column(
                    children: [
                      Container(height: 1, color: CupertinoColors.separator),
                      Expanded(child: ItemList(controller: controller)),
                    ],
                  ),
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(16),
                      color: CupertinoColors.systemBlue,
                      borderRadius: BorderRadius.circular(32),
                      child: const Icon(
                        CupertinoIcons.add,
                        color: CupertinoColors.white,
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (_) => AddItemSheet(controller: controller),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
