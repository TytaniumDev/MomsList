import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/grocery/application/grocery_controller.dart';
import 'package:moms_list/features/grocery/application/grocery_providers.dart';
import 'package:moms_list/features/grocery/presentation/grocery_item_list.dart';
import 'package:moms_list/features/grocery/presentation/suggestion_list.dart';
import 'package:moms_list/l10n/l10n.dart';

/// A store's list with the box for adding items at the top.
///
/// While Mom types, items she entered before that match replace the list,
/// so the matches stay visible above the keyboard, fading in and out as
/// they come and go. Picking one, or pressing
/// return, adds it and clears the box for the next item.
class GroceryListView extends ConsumerStatefulWidget {
  const new({required this.storeId, super.key});

  final String storeId;

  @override
  ConsumerState<GroceryListView> createState() => _GroceryListViewState();
}

class _GroceryListViewState extends ConsumerState<GroceryListView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Rebuild with new suggestions as Mom types.
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _add(String name) {
    ref
        .read(groceryControllerProvider.notifier)
        .addItem(storeId: widget.storeId, name: name);
    _controller.clear();
    // Keep the keyboard up for the next item.
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final suggestions = ref.watch(
      itemSuggestionsForProvider(
        storeId: widget.storeId,
        query: _controller.text,
      ),
    );

    return Column(
      children: [
        EntryRow(
          controller: _controller,
          focusNode: _focusNode,
          hintText: l10n.addItemHint,
          onSubmitted: _add,
          button: CoverIconButton(
            icon: Icons.add,
            tooltip: l10n.addItemButtonTooltip,
            onPressed: () => _add(_controller.text),
          ),
        ),
        Expanded(
          child: FadeSwitcher(
            duration: AppMotion.quick,
            child: suggestions.isEmpty
                ? GroceryItemList(storeId: widget.storeId)
                : SuggestionList(suggestions: suggestions, onSelected: _add),
          ),
        ),
      ],
    );
  }
}
