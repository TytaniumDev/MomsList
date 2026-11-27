import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/grocery.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(StoreMenu, () {
    late InMemoryGroceryRepository repository;
    late int doneCount;

    setUp(() async {
      repository = await seededGroceries();
      doneCount = 0;
    });

    Future<void> pumpMenu(
      WidgetTester tester, {
      double textScale = 1,
      Brightness brightness = Brightness.light,
    }) => tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: StoreMenu(onDone: () => doneCount++),
        ),
      ),
      textScale: textScale,
      brightness: brightness,
      overrides: groceryOverrides(repository),
    );

    ProviderContainer container(WidgetTester tester) =>
        ProviderScope.containerOf(tester.element(find.byType(StoreMenu)));

    testWidgets('lists every store with how many are left to get', (
      tester,
    ) async {
      await pumpMenu(tester);

      expect(find.text('Costco'), findsOneWidget);
      expect(find.text('2 to get'), findsOneWidget);
      expect(find.text('Albertsons'), findsOneWidget);
      expect(find.text('1 to get'), findsOneWidget);
    });

    testWidgets('opens the picked store', (tester) async {
      await pumpMenu(tester);

      await tester.tap(find.text('Albertsons'));
      await tester.pump();

      expect(container(tester).read(selectedStoreIdProvider), 'albertsons');
      expect(doneCount, 1);
    });

    testWidgets('opens a store after adding it', (tester) async {
      await pumpMenu(tester);

      await tester.enterText(find.byType(TextField), 'Target');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      final stores = await repository.watchStores().first;
      expect(stores.last.name, 'Target');
      expect(container(tester).read(selectedStoreIdProvider), stores.last.id);
      expect(doneCount, 1);
    });

    testWidgets('shows no stores while loading', (tester) async {
      await tester.pumpApp(
        Scaffold(body: StoreMenu(onDone: () {})),
        settle: false,
      );

      expect(find.text('Costco'), findsNothing);
    });

    for (final MapEntry(key: theme, value: brightness)
        in brightnessesUnderTest.entries) {
      testWidgets('meets accessibility guidelines on the $theme', (
        tester,
      ) async {
        await pumpMenu(tester, brightness: brightness);

        await tester.expectAccessibilityGuidelines();
      });
    }

    for (final MapEntry(key: name, value: scale)
        in textScalesUnderTest.entries) {
      testWidgets('meets accessibility guidelines at $name text size', (
        tester,
      ) async {
        await pumpMenu(tester, textScale: scale);

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
