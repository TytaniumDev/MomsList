import 'package:material_ui/material_ui.dart';

/// Shows a [ConfirmDialog]. Returns true if Mom confirms, and false if she
/// cancels or closes it.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String cancelLabel,
  required String confirmLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => ConfirmDialog(
      title: title,
      message: message,
      cancelLabel: cancelLabel,
      confirmLabel: confirmLabel,
    ),
  );
  return confirmed ?? false;
}

/// Asks before something that can't be undone, like deleting an item or
/// signing out: a question naming the thing, one sentence on what happens,
/// then Cancel and the action in the error colour. Pops true when
/// confirmed and false when cancelled.
///
/// Open it with [showConfirmDialog]. The content scrolls at large text
/// sizes.
class ConfirmDialog extends StatelessWidget {
  const new({
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
    super.key,
  });

  /// The question, such as "Delete Ketchup?"
  final String title;

  /// What happens if Mom confirms.
  final String message;
  final String cancelLabel;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      scrollable: true,
      actions: [
        TextButton(
          onPressed: () => navigator.pop(false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => navigator.pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
