import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/application/grocery_providers.dart';
import 'package:moms_list/features/grocery/domain/store.dart';
import 'package:moms_list/features/grocery/presentation/ruled_row.dart';
import 'package:moms_list/l10n/l10n.dart';

/// A store in the store picker, with how many items are left to get there.
/// The store showing now is highlighted and ticked.
class StoreTile extends ConsumerWidget {
  const new({
    required this.store,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Store store;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final items = ref.watch(storeItemsProvider(store.id)).value ?? const [];
    final toGet = items.where((item) => !item.checked).length;

    return Semantics(
      selected: selected,
      child: RuledRow(
        color: selected ? theme.colorScheme.secondaryContainer : null,
        onTap: onTap,
        child: Row(
          spacing: 6,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    l10n.storeItemsToGet(toGet),
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check,
                size: MediaQuery.textScalerOf(context).scale(24),
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
