import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/app.dart';

import 'helpers/pump_app.dart';
import 'helpers/text_scales.dart';

void main() {
  group('MomsListApp', () {
    for (final MapEntry(key: name, value: scale)
        in textScalesUnderTest.entries) {
      testWidgets('renders home screen at $name text size', (tester) async {
        await tester.pumpAtTextScale(const MomsListApp(), textScale: scale);

        expect(find.text("Mom's List"), findsOneWidget);
        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
