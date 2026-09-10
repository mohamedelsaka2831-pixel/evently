import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../models/event_model.dart';
import '../../services/event_service.dart';


class AddEditEventScreen extends StatefulWidget {
  final EventModel? event;
  const AddEditEventScreen({super.key, this.event});

  @override
  State<AddEditEventScreen> createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  EventCategory _category = EventCategory.bookClub;
  DateTime? _date;
  TimeOfDay? _time;
  final _eventService = EventService();
  bool _isSaving = false;

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _titleController = TextEditingController(text: e?.title ?? '');
    _descController = TextEditingController(text: e?.description ?? '');
    _category = e?.category ?? EventCategory.bookClub;
    _date = e?.date;
    _time = e?.time;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the title, date and time.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final event = EventModel(
        id: widget.event?.id ?? '',
        title: title,
        description: _descController.text.trim(),
        category: _category,
        date: _date!,
        time: _time!,
        isFavorite: widget.event?.isFavorite ?? false,
      );

      if (_isEditing) {
        await _eventService.updateEvent(event);
      } else {
        await _eventService.addEvent(event);
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not save event: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.watch<LocaleProvider>().isArabic;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(ar, _isEditing ? 'edit_event' : 'add_event')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        _category.imagePath,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Colors.black.withValues(alpha: 0.15),
                      ),
                      Text(
                        _titleController.text.isEmpty
                            ? _category.label
                            : _titleController.text,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: EventCategory.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final c = EventCategory.values[i];
                    final selected = c == _category;
                    return GestureDetector(
                      onTap: () => setState(() => _category = c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? theme.primaryColor : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              c.icon,
                              size: 16,
                              color: selected ? Colors.white : theme.iconTheme.color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              c.label,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : theme.textTheme.bodyMedium?.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(AppStrings.of(ar, 'title'),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(hintText: AppStrings.of(ar, 'event_title_hint')),
              ),
              const SizedBox(height: 16),
              Text(AppStrings.of(ar, 'description'),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration:
                    InputDecoration(hintText: AppStrings.of(ar, 'event_description_hint')),
              ),
              const SizedBox(height: 16),
              _DateTimeRow(
                icon: Icons.calendar_today_outlined,
                label: AppStrings.of(ar, 'event_date'),
                value: _date == null
                    ? AppStrings.of(ar, 'choose_date')
                    : DateFormat('MMM d, yyyy').format(_date!),
                onTap: _pickDate,
              ),
              const SizedBox(height: 12),
              _DateTimeRow(
                icon: Icons.access_time,
                label: AppStrings.of(ar, 'event_time'),
                value: _time == null
                    ? AppStrings.of(ar, 'choose_time')
                    : _time!.format(context),
                onTap: _pickTime,
              ),
              const SizedBox(height: 28),
              CustomButton(
                label: AppStrings.of(ar, _isEditing ? 'update_event' : 'add_event'),
                onPressed: _submit,
                isLoading: _isSaving,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateTimeRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateTimeRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondaryLight),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            value,
            style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
