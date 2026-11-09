import 'package:flutter_test/flutter_test.dart';

extension AccessibilityGuidelines on WidgetTester {
  /// Asserts the Flutter accessibility guidelines that matter most for
  /// Mom's List: tap target size, labelled targets and text contrast.
  Future<void> expectAccessibilityGuidelines() async {
    final handle = ensureSemantics();
    await expectLater(this, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(this, meetsGuideline(androidTapTargetGuideline));
    await expectLater(this, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(this, meetsGuideline(textContrastGuideline));
    handle.dispose();
  }
}
