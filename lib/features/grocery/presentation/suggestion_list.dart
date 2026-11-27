import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/grocery/domain/item_suggestions.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Items entered before that match what Mom is typing. Tapping one adds it
/// to the list.
class SuggestionList extends StatelessWidget {
  const new({required this.suggestions, required this.onSelected, super.key});

  final List<ItemSuggestion> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MarginLine(
      child: ListView(
        children: [
          for (final suggestion in suggestions)
            SuggestionRow(
              name: suggestion.name,
              whereLabel: switch (suggestion.source) {
                .onThisList => l10n.suggestionOnThisList,
                .boughtBefore => l10n.suggestionBoughtBefore,
                .otherStore => l10n.suggestionFromStore(
                  suggestion.storeName ?? '',
                ),
              },
              onTap: () => onSelected(suggestion.name),
            ),
        ],
      ),
    );
  }
}
