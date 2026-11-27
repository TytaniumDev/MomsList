import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/tokens/app_spacing.dart';
import 'package:moms_list/design_system/widgets/ruled_row.dart';

/// A store in the store menu, with a second line such as "3 to get".
/// The [selected] store has the blue band behind it and a check mark.
class StoreRow extends StatelessWidget {
  const new({
    required this.name,
    required this.countLabel,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String name;

  /// How many items are left to get there, such as "Nothing to get".
  final String countLabel;
  final bool selected;
  final VoidCallback onTap;

  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      selected: selected,
      child: RuledRow(
        color: selected ? theme.colorScheme.secondaryContainer : null,
        onTap: onTap,
        child: Row(
          spacing: AppSpacing.sm,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: theme.textTheme.bodyLarge),
                  Text(
                    countLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check,
                size: MediaQuery.textScalerOf(context).scale(_iconSize),
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
