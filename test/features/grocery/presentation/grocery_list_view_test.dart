import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/grocery.dart';
import 'package:moms_list/features/grocery/presentation/grocery_item_list.dart';
import 'package:moms_list/features/grocery/presentation/suggestion_list.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(GroceryListView, () {
    late InMemoryGroceryRepository repository;

    setUp(() async => repository = await seededGroceries());

    Future<void> pumpView(WidgetTester tester) => tester.pumpApp(
      const Scaffold(body: GroceryListView(storeId: 'costco')),
      overrides: groceryOverrides(repository),
    );

    Future<List<GroceryItem>> costcoItems() async => [
      for (final item in await repository.watchItems().first)
        if (item.storeId == 'costco') item,
    ];

    testWidgets('shows the list until Mom types', (tester) async {
      await pumpView(tester);

      expect(find.byType(GroceryItemList), findsOneWidget);
      expect(find.text('Add item'), findsOneWidget);
    });

    testWidgets('adds a new item on return and clears the box', (tester) async {
      await pumpView(tester);

      await tester.enterText(find.byType(TextField), 'Bananas');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect([
        for (final item in await costcoItems()) item.name,
      ], contains('Bananas'));
      expect(find.text('Bananas'), findsOneWidget);
      expect(find.byType(GroceryItemList), findsOneWidget);
    });

    testWidgets('adds the typed item with the add button', (tester) async {
      await pumpView(tester);

      await tester.enterText(find.byType(TextField), 'Bananas');
      await tester.tap(find.byTooltip('Add'));
      await tester.pumpAndSettle();

      expect([
        for (final item in await costcoItems()) item.name,
      ], contains('Bananas'));
    });

    testWidgets('suggests items entered before and re-adds the pick', (
      tester,
    ) async {
      await pumpView(tester);

      await tester.enterText(find.byType(TextField), 'cof');
      await tester.pump();

      expect(find.byType(SuggestionList), findsOneWidget);
      await tester.tap(
        find.text('Coffee beans · bought before', findRichText: true),
      );
      await tester.pumpAndSettle();

      final coffee = (await costcoItems()).firstWhere(
        (item) => item.name == 'Coffee beans',
      );
      expect(coffee.checked, isFalse);
      expect(find.byType(SuggestionList), findsNothing);
    });

    testWidgets("doesn't suggest other stores' items", (tester) async {
      await pumpView(tester);

      await tester.enterText(find.byType(TextField), 'mi');
      await tester.pump();

      expect(find.byType(SuggestionList), findsNothing);
    });
  });
}
