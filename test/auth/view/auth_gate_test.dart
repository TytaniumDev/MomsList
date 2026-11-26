import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/auth/auth.dart';
import 'package:moms_list/feedback/feedback.dart';
import 'package:moms_list/home/home.dart';

import '../../helpers/helpers.dart';

void main() {
  group(AuthGate, () {
    late MockAuthRepository repository;

    setUp(() => repository = MockAuthRepository());

    Future<void> pumpGate(WidgetTester tester, {double textScale = 1}) =>
        tester.pumpApp(
          const AuthGate(),
          textScale: textScale,
          overrides: [
            signInAvailableProvider.overrideWithValue(true),
            authRepositoryProvider.overrideWithValue(repository),
          ],
        );

    testWidgets('goes straight home without Firebase config', (tester) async {
      await tester.pumpApp(const AuthGate());

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('asks to sign in while signed out', (tester) async {
      when(repository.watchUser).thenAnswer((_) => Stream.value(null));
      await pumpGate(tester);

      expect(find.byType(SignInPage), findsOneWidget);
    });

    testWidgets('asks to sign in when the user cannot be read', (tester) async {
      when(repository.watchUser)
          .thenAnswer((_) => Stream.error(Exception('offline')));
      await pumpGate(tester);

      expect(find.byType(SignInPage), findsOneWidget);
    });

    testWidgets('shows home once signed in', (tester) async {
      when(repository.watchUser).thenAnswer((_) => Stream.value(testUser));
      await pumpGate(tester);

      expect(find.byType(HomePage), findsOneWidget);
    });

    group('while loading', () {
      late StreamController<AuthUser?> user;

      setUp(() {
        user = StreamController<AuthUser?>();
        addTearDown(user.close);
        when(repository.watchUser).thenAnswer((_) => user.stream);
      });

      Future<void> pumpLoading(WidgetTester tester, {double textScale = 1}) =>
          tester.pumpApp(
            const AuthGate(),
            textScale: textScale,
            settle: false,
            overrides: [
              signInAvailableProvider.overrideWithValue(true),
              authRepositoryProvider.overrideWithValue(repository),
            ],
          );

      testWidgets('shows a spinner and the feedback button', (tester) async {
        await pumpLoading(tester);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(FeedbackButton), findsOneWidget);
      });

      for (final MapEntry(key: name, value: scale)
          in textScalesUnderTest.entries) {
        testWidgets('meets accessibility guidelines at $name text size', (
          tester,
        ) async {
          await pumpLoading(tester, textScale: scale);

          await tester.expectAccessibilityGuidelines();
        });
      }
    });
  });
}
