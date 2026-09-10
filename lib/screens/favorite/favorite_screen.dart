import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/locale_provider.dart';
import '../../models/event_model.dart';
import '../../services/event_service.dart';
import '../event/event_details_screen.dart';
import '../home/widgets/event_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _searchController = TextEditingController();
  final _eventService = EventService();

  void _toggleFavorite(EventModel event) {
    _eventService.toggleFavorite(event);
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.watch<LocaleProvider>().isArabic;
    final query = _searchController.text.trim().toLowerCase();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: AppStrings.of(ar, 'search_event'),
                  prefixIcon: const Icon(Icons.search),
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
                    final favorites = events.where((e) => e.isFavorite);
                    final filtered = query.isEmpty
                        ? favorites.toList()
                        : favorites
                            .where((e) => e.title.toLowerCase().contains(query))
                            .toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'No favorite events yet',
                          style: theme.textTheme.bodyMedium,
                        ),
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
