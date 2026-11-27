import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/grocery/presentation/new_store_field.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Shown before Mom has any stores: asks her to add the first one.
class NoStoresView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        MarginLine(child: EmptyState(message: context.l10n.noStoresMessage)),
        const NewStoreField(),
      ],
    );
  }
}
