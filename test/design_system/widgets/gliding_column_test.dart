import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

/// A [GlidingColumn] of 48pt rows, one per name, that changes to [next]
/// when Switch is tapped, and back when it's tapped again.
class _Rows extends StatefulWidget {
  const new({required this.names, required this.next, this.tapped});

  final List<String> names;
  final List<String> next;
  final ValueChanged<String>? tapped;

  @override
  State<_Rows> createState() => _RowsState();
}

class _RowsState extends State<_Rows> {
  late List<String> _names = widget.names;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: () => setState(
              () => _names = _names == widget.next ? widget.names : widget.next,
            ),
            child: const Text('Switch'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: GlidingColumn(
                children: [
                  for (final name in _names)
                    ItemRow(
                      key: ValueKey(name),
                      name: name,
                      checked: false,
                      onTap: () => widget.tapped?.call(name),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  group(GlidingColumn, () {
    double topOf(WidgetTester tester, String name) =>
        tester.getTopLeft(find.text(name)).dy;

    /// Opacities of every fading layer in the column.
    List<int> fadingAlphas(WidgetTester tester) => [
      for (final layer in tester.layers.whereType<OpacityLayer>())
        if (layer.alpha! < 255) layer.alpha!,
    ];

    /// Taps Switch, then lets [elapsed] of the glide run.
    Future<void> switchFor(WidgetTester tester, Duration elapsed) async {
      await tester.tap(find.text('Switch'));
      // Rebuilds and lays out the new order, then starts the glide.
      await tester.pump();
      await tester.pump();
      await tester.pump(elapsed);
    }

    Future<void> pumpRows(
      WidgetTester tester, {
      required List<String> next,
      List<String> names = const ['Apples', 'Bread', 'Cheese'],
      ValueChanged<String>? tapped,
      Brightness brightness = Brightness.light,
    }) => tester.pumpApp(
      _Rows(names: names, next: next, tapped: tapped),
      brightness: brightness,
    );

    testWidgets('stacks its children full width, top first', (tester) async {
      await pumpRows(tester, next: const []);

      expect(topOf(tester, 'Apples'), lessThan(topOf(tester, 'Bread')));
      expect(topOf(tester, 'Bread'), lessThan(topOf(tester, 'Cheese')));
      expect(tester.getSize(find.byType(ItemRow).first).width, 402);
      expect(fadingAlphas(tester), isEmpty);
    });

    testWidgets('glides a moved child to its new place', (tester) async {
      await pumpRows(tester, next: const ['Bread', 'Cheese', 'Apples']);
      final from = topOf(tester, 'Apples');
      final to = topOf(tester, 'Cheese');

      await switchFor(tester, AppMotion.standard ~/ 2);
      expect(topOf(tester, 'Apples'), inExclusiveRange(from, to));
      expect(topOf(tester, 'Bread'), inExclusiveRange(from, to - 48));

      await tester.pumpAndSettle();
      expect(topOf(tester, 'Apples'), to);
      expect(topOf(tester, 'Bread'), from);
    });

    testWidgets('carries on from where it is when it moves again', (
      tester,
    ) async {
      await pumpRows(tester, next: const ['Bread', 'Cheese', 'Apples']);
      await switchFor(tester, AppMotion.standard ~/ 2);
      final midway = topOf(tester, 'Apples');

      // Back to the start before the first glide ends.
      await tester.tap(find.text('Switch'));
      await tester.pump();

      expect(topOf(tester, 'Apples'), moreOrLessEquals(midway));
      await tester.pumpAndSettle();
      expect(topOf(tester, 'Apples'), lessThan(midway));
    });

    testWidgets('can be tapped where a child is drawn mid-glide', (
      tester,
    ) async {
      String? tapped;
      await pumpRows(
        tester,
        next: const ['Bread', 'Cheese', 'Apples'],
        tapped: (name) => tapped = name,
      );

      await switchFor(tester, AppMotion.standard ~/ 2);
      await tester.tapAt(tester.getCenter(find.text('Apples')));

      expect(tapped, 'Apples');
    });

    testWidgets('fades in a new child', (tester) async {
      await pumpRows(tester, next: const ['Apples', 'Bananas', 'Bread']);

      await switchFor(tester, AppMotion.standard ~/ 2);
      expect(fadingAlphas(tester), [inExclusiveRange(0, 255)]);

      await tester.pumpAndSettle();
      expect(fadingAlphas(tester), isEmpty);
      expect(find.text('Bananas'), findsOneWidget);
    });

    testWidgets('closes the gap when a child is removed', (tester) async {
      await pumpRows(tester, next: const ['Apples', 'Cheese']);
      final from = topOf(tester, 'Cheese');
      final to = topOf(tester, 'Bread');

      await switchFor(tester, AppMotion.standard ~/ 2);
      expect(find.text('Bread'), findsNothing);
      expect(topOf(tester, 'Cheese'), inExclusiveRange(to, from));
    });

    testWidgets('does not animate when nothing moved', (tester) async {
      await pumpRows(tester, next: const ['Apples', 'Bread', 'Cheese']);
      final before = topOf(tester, 'Cheese');

      await switchFor(tester, AppMotion.standard ~/ 2);

      expect(topOf(tester, 'Cheese'), before);
      expect(fadingAlphas(tester), isEmpty);
    });

    testWidgets('settles at once when laid out for another reason', (
      tester,
    ) async {
      await pumpRows(tester, next: const []);

      tester.view.physicalSize = const Size(600, 874) * 3;
      await tester.pump();

      expect(tester.hasRunningAnimations, isFalse);
      expect(tester.getSize(find.byType(ItemRow).first).width, 600);
    });

    testWidgets('only fades a moved child in with Reduce Motion on', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(reduceMotion: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await pumpRows(
        tester,
        names: const ['Apples', 'Bread', 'Cheese', 'Dates'],
        next: const ['Bread', 'Apples', 'Cheese', 'Dates'],
      );
      final to = topOf(tester, 'Bread');

      await switchFor(tester, AppMotion.standard ~/ 2);

      expect(topOf(tester, 'Apples'), to);
      // Apples and Bread swapped places; Cheese and Dates stayed put.
      expect(fadingAlphas(tester), hasLength(2));
    });

    testWidgets('moves at once when animations are off', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: const _Rows(
              names: ['Apples', 'Bread', 'Cheese'],
              next: ['Bread', 'Cheese', 'Apples'],
            ),
          ),
        ),
      );
      final to = topOf(tester, 'Cheese');

      await switchFor(tester, Duration.zero);

      expect(topOf(tester, 'Apples'), to);
      expect(fadingAlphas(tester), isEmpty);
    });

    testWidgets('lets go of its layers when removed mid-fade', (tester) async {
      await pumpRows(tester, next: const ['Apples', 'Bananas', 'Bread']);
      await switchFor(tester, AppMotion.standard ~/ 2);

      await tester.pumpWidget(const SizedBox());

      expect(fadingAlphas(tester), isEmpty);
    });

    for (final MapEntry(key: theme, value: brightness)
        in brightnessesUnderTest.entries) {
      testWidgets('meets accessibility guidelines on the $theme', (
        tester,
      ) async {
        await pumpRows(
          tester,
          next: const ['Bread', 'Cheese', 'Apples'],
          brightness: brightness,
        );
        await switchFor(tester, AppMotion.standard ~/ 2);

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
