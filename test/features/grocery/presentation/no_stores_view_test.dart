import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/grocery.dart';
import 'package:moms_list/features/grocery/presentation/new_store_field.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(NoStoresView, () {
    testWidgets('asks for the first store', (tester) async {
      await tester.pumpApp(const Scaffold(body: NoStoresView()));

      expect(
        find.text('Add a store to start a list, like Costco or Albertsons.'),
        findsOneWidget,
      );
      expect(find.byType(NewStoreField), findsOneWidget);
    });
  });
}
