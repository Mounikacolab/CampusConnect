import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notice_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<NoticeProvider>().notices.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & information')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 36,
            child: Icon(Icons.school, size: 38),
          ),
          const SizedBox(height: 14),
          Text('CampusConnect',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold)),
          const Text('College Digital Notice Board',
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Card(child: ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Notices saved on this device'),
            trailing: Text('$count'),
          )),
          Card(child: const ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Data storage'),
            subtitle: Text('Notices are stored locally and remain after restarting the app.'),
          )),
          Card(child: const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Application version'),
            subtitle: Text('Version 1.0.0'),
          )),
          const SizedBox(height: 12),
          const Text(
            'This student project is a digital platform for sharing college announcements by department.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
