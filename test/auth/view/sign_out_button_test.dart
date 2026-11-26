import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/auth/auth.dart';

import '../../helpers/helpers.dart';

void main() {
  group(SignOutButton, () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository();
      when(repository.watchUser).thenAnswer((_) => Stream.value(testUser));
      when(repository.signOut).thenAnswer((_) async {});
    });

    Future<void> pumpButton(WidgetTester tester, {double textScale = 1}) =>
        tester.pumpApp(
          Scaffold(appBar: AppBar(actions: const [SignOutButton()])),
          textScale: textScale,
          overrides: [authRepositoryProvider.overrideWithValue(repository)],
        );

    testWidgets('shows nothing while signed out', (tester) async {
      when(repository.watchUser).thenAnswer((_) => Stream.value(null));
      await pumpButton(tester);

      expect(find.byTooltip('Sign out'), findsNothing);
    });

    testWidgets('signs out once confirmed', (tester) async {
      await pumpButton(tester);

      await tester.tap(find.byTooltip('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
      await tester.pumpAndSettle();

      verify(repository.signOut).called(1);
    });

    testWidgets('stays signed in when canceled', (tester) async {
      await pumpButton(tester);

      await tester.tap(find.byTooltip('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(repository.signOut);
    });

    testWidgets('stays signed in when the dialog is dismissed', (tester) async {
      await pumpButton(tester);

      await tester.tap(find.byTooltip('Sign out'));
      await tester.pumpAndSettle();
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      verifyNever(repository.signOut);
    });

    for (final MapEntry(key: name, value: scale)
        in textScalesUnderTest.entries) {
      testWidgets(
        'confirm dialog meets accessibility guidelines at $name text size',
        (tester) async {
          await pumpButton(tester, textScale: scale);

          await tester.tap(find.byTooltip('Sign out'));
          await tester.pumpAndSettle();

          await tester.expectAccessibilityGuidelines();
        },
      );
    }
  });
}
