import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/app.dart';

void main() {
  group(NotepadColors, () {
    test('copyWith replaces only the given colours', () {
      final copy = NotepadColors.light.copyWith(paper: Colors.white);

      expect(copy.paper, Colors.white);
      expect(copy.ruleLine, NotepadColors.light.ruleLine);
      expect(NotepadColors.light.copyWith().paper, NotepadColors.light.paper);
    });

    test('lerp blends towards the other colours', () {
      final halfway = NotepadColors.light.lerp(NotepadColors.dark, 1);

      expect(halfway.paper, NotepadColors.dark.paper);
      expect(halfway.ruleLine, NotepadColors.dark.ruleLine);
      expect(NotepadColors.light.lerp(null, 0.5), NotepadColors.light);
    });

    testWidgets('of reads the theme', (tester) async {
      late NotepadColors colors;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          home: Builder(
            builder: (context) {
              colors = NotepadColors.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(colors, NotepadColors.dark);
    });
  });
}
