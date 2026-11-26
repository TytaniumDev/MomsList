import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/feedback/feedback.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/grocery.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(StorePickerPage, () {
    late InMemoryGroceryRepository repository;

    setUp(() async => repository = await seededGroceries());

    /// Opens the picker from a page with a button, as the app does.
    Future<void> openPicker(WidgetTester tester, {double textScale = 1}) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => StorePickerPage.open(context),
              child: const Text('Open'),
            ),
          ),
        ),
        textScale: textScale,
        overrides: groceryOverrides(repository),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    }

    ProviderContainer container(WidgetTester tester) =>
        ProviderScope.containerOf(tester.element(find.text('Open')));

    testWidgets('lists every store with the feedback button', (tester) async {
      await openPicker(tester);

      expect(find.text('Stores'), findsOneWidget);
      expect(find.text('Costco'), findsOneWidget);
      expect(find.text('Albertsons'), findsOneWidget);
      expect(find.byType(FeedbackButton), findsOneWidget);
    });

    testWidgets('opens the picked store and goes back', (tester) async {
      await openPicker(tester);

      await tester.tap(find.text('Albertsons'));
      await tester.pumpAndSettle();

      expect(find.byType(StorePickerPage), findsNothing);
      expect(container(tester).read(selectedStoreIdProvider), 'albertsons');
    });

    testWidgets('goes back after adding a store', (tester) async {
      await openPicker(tester);

      await tester.enterText(find.byType(TextField), 'Target');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.byType(StorePickerPage), findsNothing);
      final stores = await repository.watchStores().first;
      expect(stores.last.name, 'Target');
      expect(container(tester).read(selectedStoreIdProvider), stores.last.id);
    });

    testWidgets('shows an empty list while loading', (tester) async {
      await tester.pumpApp(const StorePickerPage(), settle: false);

      expect(find.text('Costco'), findsNothing);
    });

    for (final MapEntry(key: name, value: scale)
        in textScalesUnderTest.entries) {
      testWidgets('meets accessibility guidelines at $name text size', (
        tester,
      ) async {
        await openPicker(tester, textScale: scale);

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
