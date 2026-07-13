import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/finance_entry.dart';
import '../services/finance_storage.dart';
import 'app_scaffold.dart';

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({super.key});

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  final FinanceStorage _storage = FinanceStorage();
  late Future<List<FinanceEntry>> _entriesFuture;
  List<FinanceEntry> _entries = <FinanceEntry>[];

  @override
  void initState() {
    super.initState();
    _entriesFuture = _loadEntries();
  }

  Future<List<FinanceEntry>> _loadEntries() async {
    final List<FinanceEntry> loadedEntries = await _storage.loadEntries();
    _entries = loadedEntries;
    return loadedEntries;
  }

  Future<void> _reloadEntries() async {
    setState(() {
      _entriesFuture = _loadEntries();
    });
    await _entriesFuture;
  }

  Future<void> _openEntryForm() async {
    final FinanceEntry? newEntry = await context.push<FinanceEntry>('/entries/new');

    if (newEntry == null) {
      return;
    }

    setState(() {
      _entries = <FinanceEntry>[newEntry, ..._entries];
    });
    await _storage.saveEntries(_entries);
    await _reloadEntries();
  }

  Future<void> _deleteEntry(FinanceEntry entry) async {
    setState(() {
      _entries = _entries.where((FinanceEntry item) => item.id != entry.id).toList();
    });
    await _storage.saveEntries(_entries);
    await _reloadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return FinanceFlowScaffold(
      title: 'Entries',
      selectedIndex: 1,
      child: FutureBuilder<List<FinanceEntry>>(
        future: _entriesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<FinanceEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<FinanceEntry> entries = snapshot.data ?? <FinanceEntry>[];

          return RefreshIndicator(
            onRefresh: _reloadEntries,
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Add a finance entry',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Use the form to add income or expense entries. Your changes are saved on this device.',
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _openEntryForm,
                          icon: const Icon(Icons.add),
                          label: const Text('Add entry'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (entries.isEmpty)
                  const _EmptyEntriesState()
                else
                  ...entries.map(
                    (FinanceEntry entry) => _EntryTile(
                      entry: entry,
                      onTap: () => context.go('/entry/${entry.id}'),
                      onDelete: () => _deleteEntry(entry),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    required this.entry,
    required this.onTap,
    required this.onDelete,
  });

  final FinanceEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final String amountLabel = entry.isIncome
        ? '+ ${entry.amount.toStringAsFixed(2)}'
        : '- ${entry.amount.toStringAsFixed(2)}';

    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(entry.title),
        subtitle: Text(
          '${entry.type.name.toUpperCase()} • ${entry.category} • ${_formatDate(entry.date)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(amountLabel),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete entry',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

class _EmptyEntriesState extends StatelessWidget {
  const _EmptyEntriesState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'No entries yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first income or expense entry to start tracking your finances.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class EntryFormScreen extends StatefulWidget {
  const EntryFormScreen({super.key});

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController(
    text: 'General',
  );
  EntryType _type = EntryType.expense;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final FinanceEntry entry = FinanceEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: _categoryController.text.trim(),
      date: _selectedDate,
      type: _type,
    );

    context.pop(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ADD THIS EXACT LINE:
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text(
                'New entry',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                validator: (String? value) {
                  final String trimmedValue = value?.trim() ?? '';
                  final double? parsedValue = double.tryParse(trimmedValue);
                  if (parsedValue == null || parsedValue <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SegmentedButton<EntryType>(
                segments: const <ButtonSegment<EntryType>>[
                  ButtonSegment<EntryType>(
                    value: EntryType.income,
                    label: Text('Income'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                  ButtonSegment<EntryType>(
                    value: EntryType.expense,
                    label: Text('Expense'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                ],
                selected: <EntryType>{_type},
                onSelectionChanged: (Set<EntryType> selection) {
                  setState(() {
                    _type = selection.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(
                  'Date: ${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('Save entry'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
