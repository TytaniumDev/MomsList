import 'package:material_ui/material_ui.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Placeholder landing page until the first real feature lands.
class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(l10n.homeWelcome, style: textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(l10n.homeEmptyListsMessage, style: textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
