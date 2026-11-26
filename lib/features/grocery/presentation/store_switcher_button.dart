import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/view/full_size_app_bar_title.dart';
import 'package:moms_list/features/grocery/domain/store.dart';
import 'package:moms_list/features/grocery/presentation/store_picker_page.dart';
import 'package:moms_list/l10n/l10n.dart';

/// The store's name as an app bar title, with a ▼ to show it can be tapped
/// to switch stores. Use [toolbarHeight] for the app bar so a long name
/// wraps instead of being cut off.
class StoreSwitcherButton extends StatelessWidget {
  const new({required this.store, super.key});

  final Store store;

  /// An app bar height that fits [store]'s name at Mom's text size.
  static double toolbarHeight(BuildContext context, Store store) =>
      FullSizeAppBarTitle.toolbarHeight(
        context,
        store.name,
        hasTrailingIcon: true,
      );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      hint: context.l10n.switchStoreHint,
      child: InkWell(
        onTap: () => StorePickerPage.open(context),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: FullSizeAppBarTitle(
            store.name,
            trailingIcon: Icons.arrow_drop_down,
          ),
        ),
      ),
    );
  }
}
