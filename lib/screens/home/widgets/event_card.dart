import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('d MMM').format(event.date),
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    event.category.imagePath,
                    height: 90,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 90,
                    color: Colors.black.withValues(alpha: 0.15),
                  ),
                  Text(
                    event.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  onPressed: onToggleFavorite,
                  icon: Icon(
                    event.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: event.isFavorite
                        ? AppColors.favoriteRed
                        : theme.iconTheme.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
