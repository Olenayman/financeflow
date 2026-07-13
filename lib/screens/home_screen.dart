import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FinanceFlowScaffold(
      title: 'FinanceFlow',
      selectedIndex: 0,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Track money with less friction.',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add income and expenses, review your entries, and check summary stats across the app.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton(
                        onPressed: () => context.go('/entries'),
                        child: const Text('View Entries'),
                      ),
                      OutlinedButton(
                        onPressed: () => context.go('/stats'),
                        child: const Text('View Statistics'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _HomeFeatureGrid(),
        ],
      ),
    );
  }
}

class _HomeFeatureGrid extends StatelessWidget {
  const _HomeFeatureGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isWide = constraints.maxWidth >= 700;
        final double cardWidth = isWide ? (constraints.maxWidth - 32) / 3 : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: <Widget>[
            _FeatureCard(
              width: cardWidth,
              icon: Icons.add_card_outlined,
              title: 'Income and expenses',
              description: 'Organize entries by type and category.',
            ),
            _FeatureCard(
              width: cardWidth,
              icon: Icons.category_outlined,
              title: 'Categories',
              description: 'Separate entries by spending groups.',
            ),
            _FeatureCard(
              width: cardWidth,
              icon: Icons.open_in_new,
              title: 'Entry details',
              description: 'Example route: /entry/preview-1',
              onTap: () => context.go('/entry/preview-1'),
            ),
          ],
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  final double width;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(icon, size: 32),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}