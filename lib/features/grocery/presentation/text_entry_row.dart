import 'package:material_ui/material_ui.dart';

/// A big, high-contrast text box with a button beside it, for typing a new
/// item or store. Pressing return does the same as the button.
class TextEntryRow extends StatelessWidget {
  const new({
    required this.controller,
    required this.hintText,
    required this.button,
    required this.onSubmitted,
    this.focusNode,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;

  /// Shown beside the box, usually a filled button that calls
  /// [onSubmitted] with the box's text.
  final Widget button;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: theme.colorScheme.onSurface, width: 3),
    );

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.onSurface, width: 3),
        ),
      ),
      child: Row(
        spacing: 6,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onSubmitted: onSubmitted,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: hintText,
                isDense: true,
                // Tall enough to tap at small text sizes, without extra
                // padding at large ones.
                constraints: const BoxConstraints(minHeight: 48),
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 6,
                ),
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: border.borderSide.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          button,
        ],
      ),
    );
  }
}
