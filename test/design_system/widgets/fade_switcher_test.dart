import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

/// Shows [label] in a [FadeSwitcher], and switches to [next] when tapped.
class _Switching extends StatefulWidget {
  const new({
    required this.label,
    required this.next,
    this.duration = AppMotion.standard,
  });

  final String label;
  final String next;
  final Duration duration;

  @override
  State<_Switching> createState() => _SwitchingState();
}

class _SwitchingState extends State<_Switching> {
  late String _label = widget.label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () => setState(() => _label = widget.next),
            child: const Text('Switch'),
          ),
          FadeSwitcher(
            duration: widget.duration,
            child: Text(_label, key: ValueKey(_label)),
          ),
        ],
      ),
    );
  }
}

void main() {
  group(FadeSwitcher, () {
    /// Taps Switch, then lets [elapsed] of the fade run.
    Future<void> switchFor(WidgetTester tester, Duration elapsed) async {
      await tester.tap(find.text('Switch'));
      // Rebuilds with the new child, then starts the fade.
      await tester.pump();
      await tester.pump();
      await tester.pump(elapsed);
    }

    double opacityOf(WidgetTester tester, String text) => tester
        .widget<FadeTransition>(
          find
              .ancestor(
                of: find.text(text),
                matching: find.byType(FadeTransition),
              )
              .first,
        )
        .opacity
        .value;

    testWidgets('cross-fades to a new child', (tester) async {
      await tester.pumpApp(const _Switching(label: 'Costco', next: 'Target'));

      await switchFor(tester, AppMotion.standard ~/ 2);

      expect(opacityOf(tester, 'Costco'), inExclusiveRange(0, 1));
      expect(opacityOf(tester, 'Target'), inExclusiveRange(0, 1));

      await tester.pumpAndSettle();
      expect(find.text('Costco'), findsNothing);
      expect(find.text('Target'), findsOneWidget);
    });

    testWidgets('lines children up at the top', (tester) async {
      await tester.pumpApp(const _Switching(label: 'Costco', next: 'Target'));

      await switchFor(tester, AppMotion.standard ~/ 2);

      expect(
        tester.getTopLeft(find.text('Costco')),
        tester.getTopLeft(find.text('Target')),
      );
    });

    testWidgets('hides the leaving child from taps and VoiceOver', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(const _Switching(label: 'Costco', next: 'Target'));

      await switchFor(tester, AppMotion.standard ~/ 2);

      final leaving = find.ancestor(
        of: find.text('Costco'),
        matching: find.byType(IgnorePointer),
      );
      expect(tester.widget<IgnorePointer>(leaving.first).ignoring, isTrue);
      expect(find.semantics.byLabel('Costco'), findsNothing);
      expect(find.semantics.byLabel('Target'), findsOne);
      handle.dispose();
    });

    testWidgets('takes the given duration', (tester) async {
      await tester.pumpApp(
        const _Switching(
          label: 'Costco',
          next: 'Target',
          duration: AppMotion.quick,
        ),
      );

      await switchFor(tester, AppMotion.quick);
      // A frame later, the leaving child is gone.
      await tester.pump(const Duration(milliseconds: 16));

      expect(find.text('Costco'), findsNothing);
    });

    testWidgets('switches at once when animations are off', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: const _Switching(label: 'Costco', next: 'Target'),
          ),
        ),
      );

      await tester.tap(find.text('Switch'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Costco'), findsNothing);
      expect(find.text('Target'), findsOneWidget);
    });

    for (final MapEntry(key: theme, value: brightness)
        in brightnessesUnderTest.entries) {
      testWidgets('meets accessibility guidelines on the $theme', (
        tester,
      ) async {
        await tester.pumpApp(
          const _Switching(label: 'Costco', next: 'Target'),
          brightness: brightness,
        );

        await tester.tap(find.text('Switch'));
        await tester.pump();

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
