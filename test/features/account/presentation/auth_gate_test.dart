import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/app/services/auth_service.dart';
import 'package:moms_list/features/account/account.dart';
import 'package:moms_list/features/account/presentation/sign_in_page.dart';
import 'package:moms_list/features/feedback/feedback.dart';
import 'package:moms_list/features/home/home.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(AuthGate, () {
    late MockAuthService auth;

    setUp(() => auth = MockAuthService());

    Future<void> pumpGate(
      WidgetTester tester, {
      double textScale = 1,
      bool settle = true,
    }) => tester.pumpApp(
      const AuthGate(),
      textScale: textScale,
      settle: settle,
      overrides: [
        signInAvailableProvider.overrideWithValue(true),
        authServiceProvider.overrideWithValue(auth),
      ],
    );

    testWidgets('goes straight home without Firebase config', (tester) async {
      await tester.pumpApp(const AuthGate());

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('asks to sign in while signed out', (tester) async {
      when(auth.watchUser).thenAnswer((_) => Stream.value(null));
      await pumpGate(tester);

      expect(find.byType(SignInPage), findsOneWidget);
    });

    testWidgets('asks to sign in when the user cannot be read', (tester) async {
      when(auth.watchUser)
          .thenAnswer((_) => Stream.error(Exception('offline')));
      await pumpGate(tester);

      expect(find.byType(SignInPage), findsOneWidget);
    });

    testWidgets('shows home once signed in', (tester) async {
      when(auth.watchUser).thenAnswer((_) => Stream.value(testUser));
      await pumpGate(tester);

      expect(find.byType(HomePage), findsOneWidget);
    });

    group('while loading', () {
      setUp(() {
        final user = StreamController<AuthUser?>();
        addTearDown(user.close);
        when(auth.watchUser).thenAnswer((_) => user.stream);
      });

      testWidgets('shows a spinner and the feedback button', (tester) async {
        await pumpGate(tester, settle: false);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(FeedbackButton), findsOneWidget);
      });

      for (final MapEntry(key: name, value: scale)
          in textScalesUnderTest.entries) {
        testWidgets('meets accessibility guidelines at $name text size', (
          tester,
        ) async {
          await pumpGate(tester, textScale: scale, settle: false);

          await tester.expectAccessibilityGuidelines();
        });
      }
    });
  });
}
