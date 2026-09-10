import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/event_model.dart';
import '../../services/event_service.dart';
import 'add_edit_event_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;
  const EventDetailsScreen({super.key, required this.event});

  Future<void> _confirmDelete(BuildContext context) async {
    final ar = context.read<LocaleProvider>().isArabic;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ar ? 'حذف الفعالية؟' : 'Delete event?'),
        content: Text(
          ar
              ? 'هذا الإجراء لا يمكن التراجع عنه.'
              : 'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(ar ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              ar ? 'حذف' : 'Delete',
              style: const TextStyle(color: AppColors.logoutRed),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await EventService().deleteEvent(event.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.watch<LocaleProvider>().isArabic;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(ar, 'event_details')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddEditEventScreen(event: event)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.logoutRed),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        event.category.imagePath,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black.withValues(alpha: 0.15)),
                      Text(
                        event.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                event.description,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16, color: theme.primaryColor),
                    const SizedBox(width: 8),
                    Text(DateFormat('d MMMM').format(event.date)),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: theme.primaryColor),
                    const SizedBox(width: 8),
                    Text(event.time.format(context)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(AppStrings.of(ar, 'description'),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                'Lorem ipsum dolor sit amet consectetur. Vulputate eleifend suscipit '
                'eget neque senectus a. Nulla at non malesuada odio duis lectus amet '
                'nisi sit. Risus hac enim maecenas auctor et. At cras massa diam porta '
                'facilisi lacus purus. Iaculis eget quis sit amet. Sit ac malesuada '
                'lacus quis feugiat.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
