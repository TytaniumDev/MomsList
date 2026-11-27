import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/theme/notepad_colors.dart';
import 'package:moms_list/design_system/tokens/app_spacing.dart';

/// The text box at the top of a list with its button beside it, for typing
/// a new item or store. Pressing return does the same as the button.
///
/// A heavy ink rule under the row separates it from the list.
class EntryRow extends StatelessWidget {
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

  /// Shown beside the box: a `CoverIconButton` with an add icon, or a
  /// `FilledButton` such as "Add". It should call [onSubmitted] with the
  /// box's text.
  final Widget button;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.sm),
      borderSide: BorderSide(
        color: theme.colorScheme.onSurface,
        width: AppStrokes.field,
      ),
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface,
            width: AppStrokes.heavy,
          ),
        ),
      ),
      child: Row(
        spacing: AppSpacing.sm,
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
                filled: true,
                fillColor: NotepadColors.of(context).paperField,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                // A 24pt line plus this padding makes the box as tall as
                // the button beside it (48pt) at Mom's text size.
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.row,
                ),
                border: border,
                enabledBorder: border,
                // The accent blue: navy in light mode, light blue in dark.
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
