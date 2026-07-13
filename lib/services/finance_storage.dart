import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/finance_entry.dart';

class FinanceStorage {
  static const String _entriesKey = 'financeflow_entries';
  // Accessible caching layer across all screens instantly
  static List<FinanceEntry> cachedEntries = [];

  Future<List<FinanceEntry>> loadEntries() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedEntries = prefs.getString(_entriesKey);

    if (encodedEntries == null || encodedEntries.isEmpty) {
      cachedEntries = <FinanceEntry>[]; // Assign cache
      return cachedEntries;
    }

    try {
      final Object decoded = jsonDecode(encodedEntries);

      if (decoded is! List<dynamic>) {
        cachedEntries = <FinanceEntry>[];
        return cachedEntries;
      }

      // Assign to system runtime memory cache
      cachedEntries = decoded
          .whereType<Map<String, dynamic>>()
          .map(FinanceEntry.fromJson)
          .toList();

      return cachedEntries;
    } catch (_) {
      await prefs.remove(_entriesKey);
      cachedEntries = <FinanceEntry>[];
      return cachedEntries;
    }
  }

  // Auto-sync cache on save
  Future<void> saveEntries(List<FinanceEntry> entries) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cachedEntries = entries; // Sync memory
    final String encodedEntries = jsonEncode(
      entries.map((FinanceEntry entry) => entry.toJson()).toList(),
    );
    await prefs.setString(_entriesKey, encodedEntries);
  }

  Future<void> clearEntries() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cachedEntries = [];
    await prefs.remove(_entriesKey);
  }
}