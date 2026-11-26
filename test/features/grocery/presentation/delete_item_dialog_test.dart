import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/presentation/delete_item_dialog.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('showDeleteItemDialog', () {
    late Future<bool> result;

    Future<void> open(WidgetTester tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                result = showDeleteItemDialog(context, itemName: 'Eggs'),
            child: const Text('Open'),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    }

    testWidgets('returns true when Mom deletes', (tester) async {
      await open(tester);

      expect(find.text('Delete Eggs?'), findsOneWidget);
      await tester.tap(find.text('Delete'));

      expect(await result, isTrue);
    });

    testWidgets('returns false when Mom cancels', (tester) async {
      await open(tester);

      await tester.tap(find.text('Cancel'));

      expect(await result, isFalse);
    });
  });
}
