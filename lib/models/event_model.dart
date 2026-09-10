import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_images.dart';

enum EventCategory { bookClub, sport, birthday, meeting, exhibition }

extension EventCategoryX on EventCategory {
  String get label {
    switch (this) {
      case EventCategory.bookClub:
        return 'Book club';
      case EventCategory.sport:
        return 'Sport';
      case EventCategory.birthday:
        return 'Birthday';
      case EventCategory.meeting:
        return 'Meeting';
      case EventCategory.exhibition:
        return 'Exhibition';
    }
  }

  IconData get icon {
    switch (this) {
      case EventCategory.bookClub:
        return Icons.menu_book_outlined;
      case EventCategory.sport:
        return Icons.directions_bike_outlined;
      case EventCategory.birthday:
        return Icons.cake_outlined;
      case EventCategory.meeting:
        return Icons.groups_outlined;
      case EventCategory.exhibition:
        return Icons.palette_outlined;
    }
  }

  String get imagePath {
    switch (this) {
      case EventCategory.bookClub:
        return AppImages.bookClub;
      case EventCategory.sport:
        return AppImages.sport;
      case EventCategory.birthday:
        return AppImages.birthday;
      case EventCategory.meeting:
        return AppImages.meeting;
      case EventCategory.exhibition:
        return AppImages.exhibition;
    }
  }
}


class EventModel {
  final String id;
  final String title;
  final String description;
  final EventCategory category;
  final DateTime date;
  final TimeOfDay time;
  final bool isFavorite;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    this.isFavorite = false,
  });

  EventModel copyWith({
    String? title,
    String? description,
    EventCategory? category,
    DateTime? date,
    TimeOfDay? time,
    bool? isFavorite,
  }) {
    return EventModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory EventModel.fromMap(String id, Map<String, dynamic> data) {
    final timeStr = data['time'] as String? ?? '00:00';
    final parts = timeStr.split(':');
    return EventModel(
      id: id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: EventCategory.values.firstWhere(
        (c) => c.name == data['category'],
        orElse: () => EventCategory.bookClub,
      ),
      date: (data['date'] as Timestamp).toDate(),
      time: TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
      ),
      isFavorite: data['isFavorite'] as bool? ?? false,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category.name,
      'date': Timestamp.fromDate(date),
      'time':
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      'isFavorite': isFavorite,
    };
  }
}


final List<EventModel> sampleEvents = [
  EventModel(
    id: '1',
    title: 'Birthday',
    description: 'This is a Birthday Party',
    category: EventCategory.birthday,
    date: DateTime(2026, 1, 21),
    time: const TimeOfDay(hour: 18, minute: 0),
    isFavorite: true,
  ),
  EventModel(
    id: '2',
    title: 'Meeting',
    description: 'Meeting for Updating The Development Method',
    category: EventCategory.meeting,
    date: DateTime(2026, 1, 22),
    time: const TimeOfDay(hour: 12, minute: 12),
  ),
  EventModel(
    id: '3',
    title: 'Exhibition',
    description: 'Discover unique exhibitions and talents',
    category: EventCategory.exhibition,
    date: DateTime(2026, 1, 23),
    time: const TimeOfDay(hour: 11, minute: 22),
  ),
];
