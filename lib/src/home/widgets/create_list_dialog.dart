import 'package:buynow/src/home/home_controller.dart';
import 'package:flutter/cupertino.dart';

void showCreateListDialog({
  required BuildContext context,
  required HomeController controller,
  required VoidCallback onCreated,
}) {
  final ctrl = TextEditingController();

  showCupertinoDialog(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: const Text('Neue Liste'),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: CupertinoTextField(
          controller: ctrl,
          placeholder: 'Name der Liste',
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('Abbrechen'),
          onPressed: () => Navigator.pop(dialogContext),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Erstellen'),
          onPressed: () async {
            if (ctrl.text.trim().isEmpty) return;
            await controller.createAndSelectList(ctrl.text.trim());
            if (!dialogContext.mounted) return;
            Navigator.pop(dialogContext);
            onCreated();
          },
        ),
      ],
    ),
  );
}
