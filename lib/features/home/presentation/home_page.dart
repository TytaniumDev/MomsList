import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/account/account.dart';
import 'package:moms_list/features/feedback/feedback.dart';
import 'package:moms_list/features/grocery/grocery.dart';
import 'package:moms_list/l10n/l10n.dart';

/// The app's main page: the list for the store Mom picked, with the store's
/// name in the app bar to switch stores.
class HomePage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final store = ref.watch(currentStoreProvider);
    final current = store.value;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: current == null
            ? null
            : StoreSwitcherButton.toolbarHeight(context, current),
        title: current == null
            ? Text(l10n.appTitle)
            : StoreSwitcherButton(store: current),
        actions: const [SignOutButton(), FeedbackButton()],
      ),
      body: SafeArea(
        child: switch (store) {
          AsyncData(value: final store?) => GroceryListView(
            key: ValueKey(store.id),
            storeId: store.id,
          ),
          AsyncData() => const NoStoresView(),
          AsyncError() => _Message(l10n.groceryLoadErrorMessage),
          AsyncLoading() => Center(
            child: CircularProgressIndicator(semanticsLabel: l10n.loadingLabel),
          ),
        },
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [Text(text, style: Theme.of(context).textTheme.bodyLarge)],
    );
  }
}
