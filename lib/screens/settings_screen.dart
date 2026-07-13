import 'package:flutter/material.dart';

import 'app_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FinanceFlowScaffold(
      title: 'Settings',
      selectedIndex: 3,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: const <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.storage_outlined),
              title: Text('Local storage'),
              subtitle: Text('Entries are saved on this device with shared_preferences.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.web_outlined),
              title: Text('Web deployment ready'),
              subtitle: Text('The app is structured for Flutter web deployment.'),
            ),
          ),
        ],
      ),
    );
  }
}