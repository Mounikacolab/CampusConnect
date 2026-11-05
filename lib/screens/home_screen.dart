import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notice_provider.dart';
import '../widgets/notice_card.dart';
import 'add_notice_screen.dart';
import 'notice_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoticeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CampusConnect', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('College Digital Notice Board',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          const SizedBox(width: 6),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddNoticeScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Post Notice'),
      ),
      body: RefreshIndicator(
        onRefresh: provider.loadNotices,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2457C5), Color(0xFF5285E8)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stay informed. Stay connected.',
                      style: TextStyle(color: Colors.white,
                          fontSize: 19, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('All your campus updates in one place.',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Browse by department',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: provider.departments.map((department) {
                  final selected = provider.selectedDepartment == department;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(department),
                      selected: selected,
                      onSelected: (_) => provider.selectDepartment(department),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),
            Row(children: [
              Text('Latest notices',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${provider.filteredNotices.length} items',
                  style: Theme.of(context).textTheme.bodySmall),
            ]),
            const SizedBox(height: 12),
            _buildNoticeContent(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeContent(BuildContext context, NoticeProvider provider) {
    switch (provider.status) {
      case NoticeStatus.loading:
        return const Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        );
      case NoticeStatus.error:
        return _StateMessage(
          icon: Icons.wifi_off,
          title: 'Something went wrong',
          message: provider.errorMessage ?? 'Unable to load notices.',
          actionText: 'Try again',
          onPressed: provider.loadNotices,
        );
      case NoticeStatus.empty:
        return _StateMessage(
          icon: Icons.campaign_outlined,
          title: 'No notices yet',
          message: provider.selectedDepartment == 'All'
              ? 'Post the first college announcement using the button below.'
              : 'No notices found in this department. Choose another department.',
          actionText: 'Show all departments',
          onPressed: () => provider.selectDepartment('All'),
        );
      case NoticeStatus.data:
        final notices = provider.filteredNotices;
        if (notices.isEmpty) {
          return _StateMessage(
            icon: Icons.filter_alt_off,
            title: 'No matching notices',
            message: 'There are no notices for this department.',
            actionText: 'Show all',
            onPressed: () => provider.selectDepartment('All'),
          );
        }
        return Column(
          children: notices.map((notice) => NoticeCard(
            notice: notice,
            onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => NoticeDetailScreen(notice: notice))),
          )).toList(),
        );
    }
  }
}

class _StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionText;
  final VoidCallback onPressed;

  const _StateMessage({
    required this.icon, required this.title, required this.message,
    required this.actionText, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
    child: Column(children: [
      Icon(icon, size: 44, color: Colors.blueGrey),
      const SizedBox(height: 12),
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 6),
      Text(message, textAlign: TextAlign.center),
      const SizedBox(height: 14),
      OutlinedButton(onPressed: onPressed, child: Text(actionText)),
    ]),
  );
}
