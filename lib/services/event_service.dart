import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event_model.dart';


class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _eventsRef(String uid) =>
      _db.collection('users').doc(uid).collection('events');


  Stream<List<EventModel>> watchEvents() {
    final uid = _uid;
    if (uid == null) return Stream.value(const []);
    return _eventsRef(uid).orderBy('date').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => EventModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addEvent(EventModel event) async {
    final uid = _uid;
    if (uid == null) throw Exception('You need to be signed in to add an event.');
    await _eventsRef(uid).add(event.toMap());
  }

  Future<void> updateEvent(EventModel event) async {
    final uid = _uid;
    if (uid == null) throw Exception('You need to be signed in to update an event.');
    await _eventsRef(uid).doc(event.id).update(event.toMap());
  }

  Future<void> deleteEvent(String eventId) async {
    final uid = _uid;
    if (uid == null) return;
    await _eventsRef(uid).doc(eventId).delete();
  }

  Future<void> toggleFavorite(EventModel event) async {
    final uid = _uid;
    if (uid == null) return;
    await _eventsRef(uid).doc(event.id).update({'isFavorite': !event.isFavorite});
  }
}
