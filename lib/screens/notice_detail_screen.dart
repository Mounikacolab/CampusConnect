import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/notice.dart';
import '../providers/notice_provider.dart';

class NoticeDetailScreen extends StatelessWidget {
  final Notice notice;
  const NoticeDetailScreen({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    final date = '${notice.date.day}/${notice.date.month}/${notice.date.year}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice details'),
        actions: [
          IconButton(
            tooltip: 'Delete notice',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Delete notice?'),
                  content: const Text('This notice will be removed from this device.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                await context.read<NoticeProvider>().deleteNotice(notice.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(children: [
              Icon(Icons.campaign, size: 34,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Text(notice.department,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  )),
              ),
            ]),
          ),
          const SizedBox(height: 22),
          Text(notice.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          _InfoRow(icon: Icons.calendar_today, label: 'Notice date', value: date),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.person_outline, label: 'Posted by', value: notice.postedBy),
          const Divider(height: 32),
          Text('Announcement',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SelectableText(notice.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
    const SizedBox(width: 10),
    Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
    Expanded(child: Text(value)),
  ]);
}
