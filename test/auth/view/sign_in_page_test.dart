import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/auth/auth.dart';
import 'package:moms_list/feedback/feedback.dart';

import '../../helpers/helpers.dart';

void main() {
  group(SignInPage, () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository();
      when(repository.signInWithApple)
          .thenAnswer((_) async => AuthOutcome.completed);
      when(repository.signInWithGoogle)
          .thenAnswer((_) async => AuthOutcome.completed);
    });

    Future<void> pumpPage(
      WidgetTester tester, {
      double textScale = 1,
      Brightness brightness = Brightness.light,
    }) => tester.pumpApp(
      const SignInPage(),
      textScale: textScale,
      brightness: brightness,
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );

    testWidgets('shows both sign-in buttons and the feedback button', (
      tester,
    ) async {
      await pumpPage(tester);

      expect(find.text('Sign in with Apple'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.byType(FeedbackButton), findsOneWidget);
    });

    testWidgets('signs in with Apple', (tester) async {
      await pumpPage(tester);

      await tester.tap(find.text('Sign in with Apple'));
      await tester.pumpAndSettle();

      verify(repository.signInWithApple).called(1);
    });

    testWidgets('signs in with Google', (tester) async {
      await pumpPage(tester);

      await tester.tap(find.text('Sign in with Google'));
      await tester.pumpAndSettle();

      verify(repository.signInWithGoogle).called(1);
    });

    testWidgets('turns both buttons off while signing in', (tester) async {
      final signIn = Completer<AuthOutcome>();
      when(repository.signInWithApple).thenAnswer((_) => signIn.future);
      await pumpPage(tester);

      await tester.tap(find.text('Sign in with Apple'));
      await tester.pump();

      final buttons = tester.widgetList<SignInButton>(
        find.byType(SignInButton),
      );
      expect(buttons.map((button) => button.onPressed), everyElement(isNull));
      expect(buttons.first.busy, isTrue);

      signIn.complete(AuthOutcome.canceled);
      await tester.pumpAndSettle();

      expect(
        tester
            .widgetList<SignInButton>(find.byType(SignInButton))
            .map((button) => button.onPressed),
        everyElement(isNotNull),
      );
    });

    testWidgets('says so when signing in fails', (tester) async {
      when(repository.signInWithGoogle)
          .thenAnswer((_) => Future.error(const AuthFailure('offline')));
      await pumpPage(tester);

      await tester.tap(find.text('Sign in with Google'));
      await tester.pumpAndSettle();

      expect(find.textContaining("Signing in didn't work"), findsOneWidget);
    });

    testWidgets('uses a white Apple button in dark mode', (tester) async {
      await pumpPage(tester, brightness: Brightness.dark);

      final apple = tester.widget<SignInButton>(
        find.widgetWithText(SignInButton, 'Sign in with Apple'),
      );
      expect(apple.backgroundColor, Colors.white);
      expect(apple.foregroundColor, Colors.black);
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
        when(repository.signInWithApple)
            .thenAnswer((_) => Future.error(const AuthFailure('offline')));
        await pumpPage(tester, textScale: scale);

        final error = find.textContaining("Signing in didn't work");
        final apple = find.text('Sign in with Apple');
        await tester.scrollUntilVisible(apple, 200);
        await tester.tap(apple);
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(error, 200);

        expect(error, findsOneWidget);

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
