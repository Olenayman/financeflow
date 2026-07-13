import '../models/finance_entry.dart';

class FinanceStats {
  const FinanceStats({
    required this.totalIncome,
    required this.totalSpending,
    required this.netBalance,
    required this.spendingByCategory,
    required this.spendingByMonth,
  });

  final double totalIncome;
  final double totalSpending;
  final double netBalance;
  final Map<String, double> spendingByCategory;
  final Map<String, double> spendingByMonth;

  factory FinanceStats.fromEntries(List<FinanceEntry> entries) {
    double totalIncome = 0;
    double totalSpending = 0;
    final Map<String, double> spendingByCategory = <String, double>{};
    final Map<String, double> spendingByMonth = <String, double>{};

    for (final FinanceEntry entry in entries) {
      final String monthKey = _monthKey(entry.date);
      spendingByMonth.putIfAbsent(monthKey, () => 0);

      if (entry.isIncome) {
        totalIncome += entry.amount;
      } else {
        totalSpending += entry.amount;
        spendingByCategory.update(
          entry.category,
          (double value) => value + entry.amount,
          ifAbsent: () => entry.amount,
        );
        spendingByMonth.update(
          monthKey,
          (double value) => value + entry.amount,
          ifAbsent: () => entry.amount,
        );
      }
    }

    return FinanceStats(
      totalIncome: totalIncome,
      totalSpending: totalSpending,
      netBalance: totalIncome - totalSpending,
      spendingByCategory: spendingByCategory,
      spendingByMonth: Map<String, double>.fromEntries(
        spendingByMonth.entries.toList()
          ..sort((MapEntry<String, double> a, MapEntry<String, double> b) {
            return a.key.compareTo(b.key);
          }),
      ),
    );
  }

  static String _monthKey(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month';
  }
}