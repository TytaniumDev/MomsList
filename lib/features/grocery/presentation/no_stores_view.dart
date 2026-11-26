import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/presentation/new_store_field.dart';
import 'package:moms_list/features/grocery/presentation/ruled_row.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Shown before Mom has any stores: asks her to add the first one.
class NoStoresView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: RuledRow.padding,
          child: Text(
            context.l10n.noStoresMessage,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const NewStoreField(),
      ],
    );
  }
}
