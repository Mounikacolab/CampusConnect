import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/notice.dart';
import '../providers/notice_provider.dart';

class AddNoticeScreen extends StatefulWidget {
  const AddNoticeScreen({super.key});

  @override
  State<AddNoticeScreen> createState() => _AddNoticeScreenState();
}

class _AddNoticeScreenState extends State<AddNoticeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _postedByController = TextEditingController();
  String _department = 'General';
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _postedByController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null && mounted) setState(() => _date = selected);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final notice = Notice(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        department: _department,
        description: _descriptionController.text.trim(),
        date: _date,
        postedBy: _postedByController.text.trim(),
      );
      await context.read<NoticeProvider>().addNotice(notice);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notice posted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save notice. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a notice')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Create announcement',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Share an important update with your campus.'),
            const SizedBox(height: 22),
            TextFormField(
              controller: _titleController,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Notice title',
                hintText: 'Example: Internal exam timetable',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Enter a notice title.';
                if (value.trim().length < 4) return 'Title must contain at least 4 characters.';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _department,
              decoration: const InputDecoration(
                labelText: 'Department',
                prefixIcon: Icon(Icons.apartment),
              ),
              items: context.read<NoticeProvider>().departments
                  .where((d) => d != 'All')
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _department = value);
              },
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _chooseDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Notice date',
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                child: Text('${_date.day}/${_date.month}/${_date.year}'),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              minLines: 4,
              maxLines: 8,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter the complete announcement...',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Enter the notice description.';
                if (value.trim().length < 10) return 'Description must contain at least 10 characters.';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _postedByController,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'Posted by',
                hintText: 'Example: Department Coordinator',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Enter the name of the poster.';
                return null;
              },
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send),
              label: Text(_saving ? 'Saving...' : 'Publish notice'),
            ),
          ],
        ),
      ),
    );
  }
}
