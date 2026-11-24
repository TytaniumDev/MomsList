import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/feedback/feedback.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {
  group('configureFeedbackCapture', () {
    late SentryFlutterOptions options;

    setUp(() {
      options = SentryFlutterOptions();
      configureFeedbackCapture(options);
    });

    test('attaches screenshots', () {
      expect(options.attachScreenshot, isTrue);
    });

    test('does not mask screenshots', () {
      expect(options.privacy.maskAllText, isFalse);
      expect(options.privacy.maskAllImages, isFalse);
    });

    test('sends default user and device details', () {
      expect(options.sendDefaultPii, isTrue);
    });
  });
}
