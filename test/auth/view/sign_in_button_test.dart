import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/auth/auth.dart';

import '../../helpers/helpers.dart';

void main() {
  group(SignInButton, () {
    testWidgets('shows its icon and label and can be tapped', (tester) async {
      var taps = 0;
      await tester.pumpApp(
        SignInButton(
          icon: const Icon(Icons.apple),
          label: 'Sign in with Apple',
          onPressed: () => taps++,
        ),
      );

      expect(find.byIcon(Icons.apple), findsOneWidget);
      await tester.tap(find.text('Sign in with Apple'));
      expect(taps, 1);
    });

    testWidgets('shows a spinner instead of its icon while busy', (
      tester,
    ) async {
      await tester.pumpApp(
        const SignInButton(
          icon: Icon(Icons.apple),
          label: 'Sign in with Apple',
          onPressed: null,
          busy: true,
        ),
        // The spinner never settles.
        settle: false,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.apple), findsNothing);
    });
  });
}
