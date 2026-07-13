import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EntryDetailScreen extends StatelessWidget {
  const EntryDetailScreen({super.key, required this.entryId});

  final String entryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Details'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Entry id: $entryId',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                const Text(
                  'This path-based screen will later show the selected entry details and edit actions.',
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => context.go('/entries'),
                  child: const Text('Back to entries'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}