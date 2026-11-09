import 'package:flutter/material.dart';

/// Placeholder landing screen until the first real feature lands.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Mom's List")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Welcome!', style: textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(
              'Your grocery lists will show up here.',
              style: textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
