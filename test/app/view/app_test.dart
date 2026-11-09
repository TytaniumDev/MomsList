import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/app/app.dart';
import 'package:moms_list/home/home.dart';

import '../../helpers/helpers.dart';

void main() {
  group(App, () {
    testWidgets('renders $HomePage', (tester) async {
      await tester.pumpRootApp(const App());

      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
