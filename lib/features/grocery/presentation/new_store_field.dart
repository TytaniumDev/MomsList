import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/application/current_store.dart';
import 'package:moms_list/features/grocery/application/grocery_controller.dart';
import 'package:moms_list/features/grocery/presentation/text_entry_row.dart';
import 'package:moms_list/l10n/l10n.dart';

/// A box for adding a store, such as Costco. The new store's list opens
/// straight away, and [onAdded] runs after it is added.
class NewStoreField extends ConsumerStatefulWidget {
  const new({this.onAdded, super.key});

  final VoidCallback? onAdded;

  @override
  ConsumerState<NewStoreField> createState() => _NewStoreFieldState();
}

class _NewStoreFieldState extends ConsumerState<NewStoreField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    final id = ref.read(groceryControllerProvider.notifier).addStore(name);
    ref.read(selectedStoreIdProvider.notifier).select(id);
    _controller.clear();
    widget.onAdded?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextEntryRow(
      controller: _controller,
      hintText: l10n.newStoreHint,
      onSubmitted: (_) => _add(),
      button: FilledButton(
        onPressed: _add,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        child: Text(l10n.addStoreButton),
      ),
    );
  }
}
