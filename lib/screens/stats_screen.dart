import 'package:flutter/material.dart';

import 'app_scaffold.dart';
import '../models/finance_entry.dart';
import '../services/finance_stats.dart';
import '../services/finance_storage.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late final Future<List<FinanceEntry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _entriesFuture = FinanceStorage().loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return FinanceFlowScaffold(
      title: 'Statistics',
      selectedIndex: 2,
      child: FutureBuilder<List<FinanceEntry>>(
        future: _entriesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<FinanceEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<FinanceEntry> entries = snapshot.data ?? <FinanceEntry>[];
          final FinanceStats stats = FinanceStats.fromEntries(entries);

          if (entries.isEmpty) {
            return const _EmptyStatsState();
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _StatCard(
                    label: 'Total Income',
                    value: stats.totalIncome.toStringAsFixed(2),
                  ),
                  _StatCard(
                    label: 'Total Spending',
                    value: stats.totalSpending.toStringAsFixed(2),
                  ),
                  _StatCard(
                    label: 'Net Balance',
                    value: stats.netBalance.toStringAsFixed(2),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Spending by category',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      if (stats.spendingByCategory.isEmpty)
                        const Text('No spending yet.')
                      else
                        ...stats.spendingByCategory.entries.map(
                          (MapEntry<String, double> entry) => _CategoryRow(
                            label: entry.key,
                            amount: entry.value.toStringAsFixed(2),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Spending over time',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _MonthBars(monthlySpending: stats.spendingByMonth),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.label, required this.amount});

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(amount),
    );
  }
}

class _MonthBars extends StatelessWidget {
  const _MonthBars({required this.monthlySpending});

  final Map<String, double> monthlySpending;

  @override
  Widget build(BuildContext context) {
    if (monthlySpending.isEmpty) {
      return const Text('No spending data available yet.');
    }

    final double maxAmount = monthlySpending.values.fold<double>(
      0,
      (double previous, double amount) => amount > previous ? amount : previous,
    );

    return Column(
      children: monthlySpending.entries.map((MapEntry<String, double> entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: <Widget>[
              SizedBox(width: 96, child: Text(entry.key)),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 14,
                    value: maxAmount == 0 ? 0 : entry.value / maxAmount,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 72,
                child: Text(
                  entry.value.toStringAsFixed(2),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _EmptyStatsState extends StatelessWidget {
  const _EmptyStatsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'No saved entries yet.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add entries later and this screen will summarize your totals, category spending, and monthly trends.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}