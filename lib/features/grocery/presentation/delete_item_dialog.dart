import 'package:material_ui/material_ui.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Asks whether to delete [itemName] for good. Returns true if Mom says
/// yes.
Future<bool> showDeleteItemDialog(
  BuildContext context, {
  required String itemName,
}) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.deleteItemDialogTitle(itemName)),
      content: Text(l10n.deleteItemDialogMessage),
      scrollable: true,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.deleteItemDialogCancelButton),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.deleteItemDialogConfirmButton),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
