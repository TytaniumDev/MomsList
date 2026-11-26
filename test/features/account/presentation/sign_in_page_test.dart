import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/app/services/auth_service.dart';
import 'package:moms_list/features/account/presentation/sign_in_page.dart';
import 'package:moms_list/features/feedback/feedback.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(SignInPage, () {
    late MockAuthService auth;

    setUp(() {
      auth = MockAuthService();
      when(auth.signInWithGoogle)
          .thenAnswer((_) async => AuthOutcome.completed);
    });

    Future<void> pumpPage(WidgetTester tester, {double textScale = 1}) =>
        tester.pumpApp(
          const SignInPage(),
          textScale: textScale,
          overrides: [authServiceProvider.overrideWithValue(auth)],
        );

    final googleButton = find.text('Sign in with Google');
    final error = find.textContaining("Signing in didn't work");

    testWidgets('shows the Google button and the feedback button', (
      tester,
    ) async {
      await pumpPage(tester);

      expect(googleButton, findsOneWidget);
      expect(find.byType(FeedbackButton), findsOneWidget);
    });

    testWidgets('signs in with Google', (tester) async {
      await pumpPage(tester);

      await tester.tap(googleButton);
      await tester.pumpAndSettle();

      verify(auth.signInWithGoogle).called(1);
      expect(error, findsNothing);
    });

    testWidgets('turns the button off and shows a spinner while signing in', (
      tester,
    ) async {
      final signIn = Completer<AuthOutcome>();
      when(auth.signInWithGoogle).thenAnswer((_) => signIn.future);
      await pumpPage(tester);

      await tester.tap(googleButton);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(googleButton);
      verify(auth.signInWithGoogle).called(1);

      signIn.complete(AuthOutcome.canceled);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('says so when signing in fails', (tester) async {
      when(auth.signInWithGoogle)
          .thenAnswer((_) => Future.error(const AuthFailure('offline')));
      await pumpPage(tester);

      await tester.tap(googleButton);
      await tester.pumpAndSettle();

      expect(error, findsOneWidget);
    });

    for (final MapEntry(key: name, value: scale)
        in textScalesUnderTest.entries) {
      testWidgets('meets accessibility guidelines at $name text size', (
        tester,
      ) async {
        await pumpPage(tester, textScale: scale);

        await tester.expectAccessibilityGuidelines();
      });

      testWidgets('shows the error accessibly at $name text size', (
        tester,
      ) async {
        when(auth.signInWithGoogle)
            .thenAnswer((_) => Future.error(const AuthFailure('offline')));
        await pumpPage(tester, textScale: scale);

        await tester.scrollUntilVisible(googleButton, 200);
        await tester.ensureVisible(googleButton);
        await tester.pumpAndSettle();
        await tester.tap(googleButton);
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(error, 200);

        expect(error, findsOneWidget);
        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
