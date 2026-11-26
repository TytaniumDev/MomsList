import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/app/services/auth_service.dart';
import 'package:moms_list/features/account/account.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(SignOutButton, () {
    late MockAuthService auth;

    setUp(() {
      auth = MockAuthService();
      when(auth.watchUser).thenAnswer((_) => Stream.value(testUser));
      when(auth.signOut).thenAnswer((_) async {});
    });

    Future<void> pumpButton(WidgetTester tester, {double textScale = 1}) =>
        tester.pumpApp(
          Scaffold(appBar: AppBar(actions: const [SignOutButton()])),
          textScale: textScale,
          overrides: [authServiceProvider.overrideWithValue(auth)],
        );

    Future<void> openDialog(WidgetTester tester) async {
      await tester.tap(find.byTooltip('Sign out'));
      await tester.pumpAndSettle();
    }

    testWidgets('shows nothing while signed out', (tester) async {
      when(auth.watchUser).thenAnswer((_) => Stream.value(null));
      await pumpButton(tester);

      expect(find.byTooltip('Sign out'), findsNothing);
    });

    testWidgets('signs out once confirmed', (tester) async {
      await pumpButton(tester);

      await openDialog(tester);
      await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
      await tester.pumpAndSettle();

      verify(auth.signOut).called(1);
    });

    testWidgets('stays signed in when canceled', (tester) async {
      await pumpButton(tester);

      await openDialog(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(auth.signOut);
    });

    testWidgets('stays signed in when the dialog is dismissed', (tester) async {
      await pumpButton(tester);

      await openDialog(tester);
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      verifyNever(auth.signOut);
    });

    for (final MapEntry(key: name, value: scale)
        in textScalesUnderTest.entries) {
      testWidgets(
        'confirm dialog meets accessibility guidelines at $name text size',
        (tester) async {
          await pumpButton(tester, textScale: scale);

          await openDialog(tester);

          await tester.expectAccessibilityGuidelines();
        },
      );
    }
  });
}
