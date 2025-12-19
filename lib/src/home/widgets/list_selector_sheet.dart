import 'package:buynow/src/home/home_controller.dart';
import 'package:buynow/src/home/widgets/create_list_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

void showListSelectorSheet({
  required BuildContext context,
  required HomeController controller,
  required VoidCallback onChanged,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: controller.lists,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CupertinoActionSheet(
            title: Text('Liste auswählen'),
            message: CupertinoActivityIndicator(),
          );
        }

        return CupertinoActionSheet(
          title: const Text('Liste auswählen'),
          actions: [
            ...snapshot.data!.docs.map((doc) {
              return CupertinoActionSheetAction(
                onPressed: () async {
                  await controller.setActiveList(doc.id, doc['name']);
                  onChanged();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: Text(doc['name']),
              );
            }),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                showCreateListDialog(
                  context: context,
                  controller: controller,
                  onCreated: onChanged,
                );
              },
              child: const Text('➕ Neue Liste'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
        );
      },
    ),
  );
}
