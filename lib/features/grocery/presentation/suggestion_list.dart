import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/domain/item_suggestions.dart';
import 'package:moms_list/features/grocery/presentation/ruled_row.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Items entered before that match what Mom is typing. Tapping one adds it
/// to the list.
class SuggestionList extends StatelessWidget {
  const new({required this.suggestions, required this.onSelected, super.key});

  final List<ItemSuggestion> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final suggestion in suggestions)
          _SuggestionTile(
            suggestion: suggestion,
            onTap: () => onSelected(suggestion.name),
          ),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const new({required this.suggestion, required this.onTap});

  final ItemSuggestion suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final where = switch (suggestion.source) {
      .onThisList => l10n.suggestionOnThisList,
      .boughtBefore => l10n.suggestionBoughtBefore,
      .otherStore => l10n.suggestionFromStore(suggestion.storeName ?? ''),
    };

    return RuledRow(
      color: theme.colorScheme.surface,
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: suggestion.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: ' · $where',
              style: theme.textTheme.labelLarge?.copyWith(
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
