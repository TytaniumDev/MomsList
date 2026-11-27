import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/app/services/auth_service.dart';
import 'package:moms_list/features/feedback/feedback.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/domain/grocery_repository.dart';
import 'package:moms_list/features/grocery/grocery.dart';
import 'package:moms_list/features/home/home.dart';

import '../../../helpers/helpers.dart';

class _MockGroceryRepository extends Mock implements GroceryRepository;

void main() {
  group(HomePage, () {
    testWidgets("shows the first store's list", (tester) async {
      await tester.pumpApp(
        const HomePage(),
        overrides: groceryOverrides(await seededGroceries()),
      );

      expect(find.byType(StoreSwitcherButton), findsOneWidget);
      expect(find.text('Costco'), findsOneWidget);
      expect(find.text('Eggs'), findsOneWidget);
      expect(find.byType(FeedbackButton), findsOneWidget);
    });

    testWidgets('switches stores from the app bar', (tester) async {
      await tester.pumpApp(
        const HomePage(),
        overrides: groceryOverrides(await seededGroceries()),
      );

      await tester.tap(find.text('Costco'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Albertsons'));
      await tester.pumpAndSettle();

      expect(find.text('Milk'), findsOneWidget);
      expect(find.text('Eggs'), findsNothing);
    });

    testWidgets('asks for a store before there are any', (tester) async {
      await tester.pumpApp(
        const HomePage(),
        overrides: groceryOverrides(InMemoryGroceryRepository()),
      );

      expect(find.byType(NoStoresView), findsOneWidget);
      expect(find.text("Mom's List"), findsOneWidget);
    });

    testWidgets('shows a spinner while loading', (tester) async {
      final repository = _MockGroceryRepository();
      final stores = StreamController<List<Store>>();
      addTearDown(stores.close);
      when(repository.watchStores).thenAnswer((_) => stores.stream);
      when(repository.watchItems).thenAnswer((_) => const Stream.empty());

      await tester.pumpApp(
        const HomePage(),
        settle: false,
        overrides: [groceryRepositoryProvider.overrideWithValue(repository)],
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('says when the lists cannot be loaded', (tester) async {
      final repository = _MockGroceryRepository();
      when(repository.watchStores)
          .thenAnswer((_) => Stream.error(Exception('offline')));
      when(repository.watchItems).thenAnswer((_) => const Stream.empty());

      await tester.pumpApp(
        const HomePage(),
        overrides: [groceryRepositoryProvider.overrideWithValue(repository)],
      );

      expect(
        find.text(
          "Your lists couldn't be loaded. "
          'Please check your internet connection.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows the sign-out button when signed in', (tester) async {
      final auth = MockAuthService();
      when(auth.watchUser).thenAnswer((_) => Stream.value(testUser));

      await tester.pumpApp(
        const HomePage(),
        overrides: [authServiceProvider.overrideWithValue(auth)],
      );

      expect(find.byTooltip('Sign out'), findsOneWidget);
    });

    testWidgets('meets accessibility guidelines in dark mode', (tester) async {
      await tester.pumpApp(
        const HomePage(),
        brightness: Brightness.dark,
        overrides: groceryOverrides(await seededGroceries()),
      );

      await tester.expectAccessibilityGuidelines();
    });

    for (final MapEntry(key: name, value: scale)
        in textScalesUnderTest.entries) {
      testWidgets('meets accessibility guidelines at $name text size', (
        tester,
      ) async {
        await tester.pumpApp(
          const HomePage(),
          textScale: scale,
          overrides: groceryOverrides(await seededGroceries()),
        );

        await tester.expectAccessibilityGuidelines();
      });

      testWidgets('meets accessibility guidelines with no stores at $name '
          'text size', (tester) async {
        await tester.pumpApp(const HomePage(), textScale: scale);

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
