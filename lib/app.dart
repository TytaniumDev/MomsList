import 'package:flutter/material.dart';
import 'package:moms_list/features/home/home_screen.dart';
import 'package:moms_list/theme/app_theme.dart';

/// Root widget for Mom's List.
///
/// Text scaling is intentionally left unclamped so the app always honours the
/// system text size the user has chosen.
class MomsListApp extends StatelessWidget {
  const MomsListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mom's List",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      highContrastTheme: AppTheme.light(highContrast: true),
      highContrastDarkTheme: AppTheme.dark(highContrast: true),
      home: const HomeScreen(),
    );
  }
}
