import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../models/event_model.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../event/event_details_screen.dart';
import 'widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  EventCategory? _selectedCategory;
  final _eventService = EventService();
  final _authService = AuthService();

  void _toggleFavorite(EventModel event) {
    _eventService.toggleFavorite(event);
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.watch<LocaleProvider>().isArabic;
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final displayName = _authService.currentUser?.displayName;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.of(ar, 'welcome_back_wave'),
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        (displayName != null && displayName.isNotEmpty)
                            ? displayName
                            : 'John Safwat',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => themeProvider.toggleTheme(!themeProvider.isDarkMode),
                        child: CircleAvatar(
                          backgroundColor: theme.colorScheme.surface,
                          child: Icon(
                            themeProvider.isDarkMode
                                ? Icons.nightlight_outlined
                                : Icons.wb_sunny_outlined,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => context.read<LocaleProvider>().toggle(),
                        child: CircleAvatar(
                          backgroundColor: theme.primaryColor,
                          child: Text(
                            ar ? 'AR' : 'EN',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryChip(
                      label: AppStrings.of(ar, 'all'),
                      selected: _selectedCategory == null,
                      onTap: () => setState(() => _selectedCategory = null),
                    ),
                    const SizedBox(width: 8),
                    ...EventCategory.values.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _CategoryChip(
                          label: c.label,
                          icon: c.icon,
                          selected: _selectedCategory == c,
                          onTap: () => setState(() => _selectedCategory = c),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<EventModel>>(
                  stream: _eventService.watchEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Could not load events.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }
                    final events = snapshot.data ?? const [];
                    final filtered = _selectedCategory == null
                        ? events
                        : events.where((e) => e.category == _selectedCategory).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text('No events', style: theme.textTheme.bodyMedium),
                      );
                    }
                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final event = filtered[i];
                        return EventCard(
                          event: event,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EventDetailsScreen(event: event),
                            ),
                          ),
                          onToggleFavorite: () => _toggleFavorite(event),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? theme.primaryColor : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : theme.iconTheme.color,
              ),
              const SizedBox(width: 6),
            ] else if (selected) ...[
              const Icon(Icons.grid_view_rounded, size: 16, color: Colors.white),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : theme.textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
