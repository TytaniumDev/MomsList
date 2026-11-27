import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(EntryRow, () {
    testWidgets('submits the typed text on return', (tester) async {
      String? submitted;
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpApp(
        Scaffold(
          body: EntryRow(
            controller: controller,
            hintText: 'Add item',
            button: const Text('Go'),
            onSubmitted: (text) => submitted = text,
          ),
        ),
      );

      expect(find.text('Add item'), findsOneWidget);
      expect(find.text('Go'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Milk');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(submitted, 'Milk');
    });
  });
}
