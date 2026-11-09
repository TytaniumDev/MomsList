import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/theme/app_theme.dart';
import 'package:moms_list/home/home.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Text scaling is intentionally left unclamped so the app always honours
/// the system text size the user has chosen.
class App extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      highContrastTheme: AppTheme.light(highContrast: true),
      highContrastDarkTheme: AppTheme.dark(highContrast: true),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
