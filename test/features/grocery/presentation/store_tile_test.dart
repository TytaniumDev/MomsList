import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/grocery.dart';
import 'package:moms_list/features/grocery/presentation/store_tile.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(StoreTile, () {
    final costco = Store(
      id: 'costco',
      name: 'Costco',
      createdAt: DateTime(2026),
    );
    final empty = Store(id: 'empty', name: 'Target', createdAt: DateTime(2026));

    Future<void> pumpTile(
      WidgetTester tester,
      Store store, {
      bool selected = false,
      VoidCallback? onTap,
    }) async {
      final repository = await seededGroceries();
      await tester.pumpApp(
        Scaffold(
          body: StoreTile(
            store: store,
            selected: selected,
            onTap: onTap ?? () {},
          ),
        ),
        overrides: groceryOverrides(repository),
      );
    }

    testWidgets('shows how many items are left to get', (tester) async {
      await pumpTile(tester, costco);

      expect(find.text('Costco'), findsOneWidget);
      expect(find.text('2 to get'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('says when there is nothing to get', (tester) async {
      await pumpTile(tester, empty);

      expect(find.text('Nothing to get'), findsOneWidget);
    });

    testWidgets('ticks the selected store', (tester) async {
      await pumpTile(tester, costco, selected: true);

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await pumpTile(tester, costco, onTap: () => tapped = true);

      await tester.tap(find.text('Costco'));

      expect(tapped, isTrue);
    });

    testWidgets('shows nothing to get while loading', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: StoreTile(store: costco, selected: false, onTap: () {}),
        ),
        settle: false,
      );

      expect(find.text('Nothing to get'), findsOneWidget);
    });
  });
}
