import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/widgets/ruled_row.dart';

/// An item entered before that matches what Mom is typing, followed by
/// where it came from, such as "bought before".
class SuggestionRow extends StatelessWidget {
  const new({
    required this.name,
    required this.whereLabel,
    required this.onTap,
    super.key,
  });

  final String name;

  /// Where the suggestion came from: "already on list", "bought before" or
  /// "from Costco".
  final String whereLabel;

  /// Usually adds the item to the list.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RuledRow(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: name),
            TextSpan(
              text: ' · $whereLabel',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}
