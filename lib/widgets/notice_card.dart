import 'package:flutter/material.dart';
import '../models/notice.dart';

class NoticeCard extends StatelessWidget {
  final Notice notice;
  final VoidCallback onTap;

  const NoticeCard({super.key, required this.notice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final date = '${notice.date.day.toString().padLeft(2, '0')}/'
        '${notice.date.month.toString().padLeft(2, '0')}/${notice.date.year}';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(notice.department,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                const Spacer(),
                Text(date, style: Theme.of(context).textTheme.bodySmall),
              ]),
              const SizedBox(height: 12),
              Text(notice.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 6),
              Text(
                notice.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blueGrey.shade700,
                    ),
              ),
              const SizedBox(height: 10),
              Row(children: [
                const Icon(Icons.person_outline, size: 16),
                const SizedBox(width: 5),
                Text(notice.postedBy, style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
