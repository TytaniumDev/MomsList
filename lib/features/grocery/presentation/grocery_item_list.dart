import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/theme/app_spacing.dart';
import 'package:moms_list/features/grocery/application/grocery_providers.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/presentation/grocery_item_tile.dart';
import 'package:moms_list/features/grocery/presentation/margin_line.dart';
import 'package:moms_list/features/grocery/presentation/ruled_row.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Every item at [storeId]: what to get at the top, then everything already
/// checked off under a "Got it" heading.
class GroceryItemList extends ConsumerWidget {
  const new({required this.storeId, super.key});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(storeItemsProvider(storeId)).value ?? const [];
    final toGet = items.where((item) => !item.checked).toList();
    final gotIt = items.where((item) => item.checked).toList();

    return MarginLine(
      child: ListView(
        children: [
          for (final item in toGet) _tile(item),
          if (toGet.isEmpty) const _NothingToGet(),
          if (gotIt.isNotEmpty) _GotItHeading(count: gotIt.length),
          for (final item in gotIt) _tile(item),
        ],
      ),
    );
  }

  Widget _tile(GroceryItem item) =>
      GroceryItemTile(key: ValueKey(item.id), item: item);
}

class _NothingToGet extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: RuledRow.padding,
      child: Text(
        context.l10n.groceryListEmptyMessage,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _GotItHeading extends StatelessWidget {
  const new({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.textInset,
        AppSpacing.md,
        AppSpacing.row,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.onSurface,
            width: AppStrokes.heavy,
          ),
        ),
      ),
      child: Semantics(
        header: true,
        child: Text(
          context.l10n.gotItHeading(count),
          style: theme.textTheme.titleSmall,
        ),
      ),
    );
  }
}
