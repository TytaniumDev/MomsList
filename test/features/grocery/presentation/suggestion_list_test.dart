import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/grocery.dart';
import 'package:moms_list/features/grocery/presentation/suggestion_list.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(SuggestionList, () {
    const suggestions = [
      ItemSuggestion(name: 'Milk', source: .onThisList),
      ItemSuggestion(name: 'Mints', source: .boughtBefore),
      ItemSuggestion(
        name: 'Mixed nuts',
        source: .otherStore,
        storeName: 'Costco',
      ),
      ItemSuggestion(name: 'Mango', source: .otherStore),
    ];

    testWidgets('says where each suggestion was entered', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: SuggestionList(suggestions: suggestions, onSelected: (_) {}),
        ),
      );

      expect(find.text('Milk · already on list', findRichText: true), findsOne);
      expect(find.text('Mints · bought before', findRichText: true), findsOne);
      expect(
        find.text('Mixed nuts · from Costco', findRichText: true),
        findsOne,
      );
      expect(find.text('Mango · from ', findRichText: true), findsOne);
    });

    testWidgets('picks the tapped suggestion', (tester) async {
      String? picked;
      await tester.pumpApp(
        Scaffold(
          body: SuggestionList(
            suggestions: suggestions,
            onSelected: (name) => picked = name,
          ),
        ),
      );

      await tester.tap(find.text('Mints · bought before', findRichText: true));

      expect(picked, 'Mints');
    });
  });
}
