import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/account/account.dart';
import 'package:moms_list/features/feedback/feedback.dart';
import 'package:moms_list/features/grocery/grocery.dart';
import 'package:moms_list/l10n/l10n.dart';

/// The app's main page: the list for the store Mom picked, with the store's
/// name in the header to switch stores.
class HomePage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final store = ref.watch(currentStoreProvider);
    final current = store.value;

    return PageScaffold(
      title: current?.name ?? l10n.appTitle,
      titleDropdown: current == null
          ? null
          : (menuContext) =>
                StoreMenu(onDone: () => Navigator.of(menuContext).pop()),
      titleTapHint: l10n.switchStoreHint,
      actions: const [SignOutButton(), FeedbackButton()],
      body: switch (store) {
        AsyncData(value: final store?) => GroceryListView(
          key: ValueKey(store.id),
          storeId: store.id,
        ),
        AsyncData() => const NoStoresView(),
        AsyncError() => ListView(
          children: [
            EmptyState(message: l10n.groceryLoadErrorMessage, isError: true),
          ],
        ),
        AsyncLoading() => Center(
          child: CircularProgressIndicator(semanticsLabel: l10n.loadingLabel),
        ),
      },
    );
  }
}
