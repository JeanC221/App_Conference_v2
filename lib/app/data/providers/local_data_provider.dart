import 'dart:convert';
import 'package:get/get.dart';
import '../models/event_model.dart';
import '../models/track_model.dart';
import '../models/feedback_model.dart';
import '../services/storage_service.dart';

class LocalDataProvider {
  final StorageService _storageService = Get.find<StorageService>();

  // Keys for SharedPreferences
  static const String _tracksKey = 'tracks';
  static const String _eventsKey = 'events';
  static const String _subscribedEventsKey = 'subscribed_events';
  static const String _feedbackKey = 'feedback';

  // Sample data for initial setup
  final List<Track> _sampleTracks = [
    Track(
      id: '1',
      name: 'Mobile Development',
      description: 'Sessions about mobile app development technologies and practices',
    ),
    Track(
      id: '2',
      name: 'Web Development',
      description: 'Latest trends and technologies in web development',
    ),
    Track(
      id: '3',
      name: 'AI & Machine Learning',
      description: 'Artificial intelligence and machine learning applications',
    ),
  ];

  final List<Event> _sampleEvents = [
    Event(
      id: '1',
      name: 'Flutter for Beginners',
      location: 'Room A101',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      maxParticipants: 50,
      currentParticipants: 30,
      description: 'Introduction to Flutter framework for cross-platform development',
      trackId: '1',
    ),
    Event(
      id: '2',
      name: 'Advanced React Patterns',
      location: 'Room B202',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      maxParticipants: 40,
      currentParticipants: 35,
      description: 'Deep dive into advanced React patterns and best practices',
      trackId: '2',
    ),
    Event(
      id: '3',
      name: 'TensorFlow Workshop',
      location: 'Room C303',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      maxParticipants: 30,
      currentParticipants: 25,
      description: 'Hands-on workshop with TensorFlow for machine learning',
      trackId: '3',
    ),
    Event(
      id: '4',
      name: 'Kotlin for Android',
      location: 'Room A102',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      maxParticipants: 45,
      currentParticipants: 40,
      description: 'Using Kotlin for Android app development',
      trackId: '1',
      averageRating: 4.5,
    ),
  ];

  // Initialize with sample data if empty
  Future<void> initializeIfEmpty() async {
    if (_storageService.getString(_tracksKey) == null) {
      await saveTracks(_sampleTracks);
    }
    
    if (_storageService.getString(_eventsKey) == null) {
      await saveEvents(_sampleEvents);
    }
  }

  // Get all tracks
  List<Track> getTracks() {
    final String? tracksJson = _storageService.getString(_tracksKey);
    if (tracksJson == null) return [];
    
    final List<dynamic> decodedTracks = jsonDecode(tracksJson);
    return decodedTracks.map((track) => Track.fromJson(track)).toList();
  }

  // Save tracks
  Future<void> saveTracks(List<Track> tracks) async {
    final List<Map<String, dynamic>> encodedTracks = 
        tracks.map((track) => track.toJson()).toList();
    await _storageService.saveString(_tracksKey, jsonEncode(encodedTracks));
  }

  // Get all events
  List<Event> getEvents() {
    final String? eventsJson = _storageService.getString(_eventsKey);
    if (eventsJson == null) return [];
    
    final List<dynamic> decodedEvents = jsonDecode(eventsJson);
    return decodedEvents.map((event) => Event.fromJson(event)).toList();
  }

  // Save events
  Future<void> saveEvents(List<Event> events) async {
    final List<Map<String, dynamic>> encodedEvents = 
        events.map((event) => event.toJson()).toList();
    await _storageService.saveString(_eventsKey, jsonEncode(encodedEvents));
  }

  // Get events by track
  List<Event> getEventsByTrack(String trackId) {
    return getEvents().where((event) => event.trackId == trackId).toList();
  }

  // Get subscribed events
  List<String> getSubscribedEventIds() {
    return _storageService.getStringList(_subscribedEventsKey) ?? [];
  }

  // Get subscribed events with details
  List<Event> getSubscribedEvents() {
    final List<String> subscribedIds = getSubscribedEventIds();
    return getEvents().where((event) => subscribedIds.contains(event.id)).toList();
  }

  // Subscribe to an event
  Future<bool> subscribeToEvent(String eventId) async {
    List<String> subscribedIds = getSubscribedEventIds();
    if (subscribedIds.contains(eventId)) return false;
    
    subscribedIds.add(eventId);
    return await _storageService.saveStringList(_subscribedEventsKey, subscribedIds);
  }

  // Unsubscribe from an event
  Future<bool> unsubscribeFromEvent(String eventId) async {
    List<String> subscribedIds = getSubscribedEventIds();
    if (!subscribedIds.contains(eventId)) return false;
    
    subscribedIds.remove(eventId);
    return await _storageService.saveStringList(_subscribedEventsKey, subscribedIds);
  }

  // Check if subscribed to an event
  bool isSubscribedToEvent(String eventId) {
    return getSubscribedEventIds().contains(eventId);
  }

  // Get feedback for an event
  List<EventFeedback> getFeedbackForEvent(String eventId) {
    final String? feedbackJson = _storageService.getString(_feedbackKey);
    if (feedbackJson == null) return [];
    
    final List<dynamic> decodedFeedback = jsonDecode(feedbackJson);
    final List<EventFeedback> allFeedback = 
        decodedFeedback.map((feedback) => EventFeedback.fromJson(feedback)).toList();
    
    return allFeedback.where((feedback) => feedback.eventId == eventId).toList();
  }

  // Save feedback for an event
  Future<bool> saveFeedback(EventFeedback feedback) async {
    List<EventFeedback> allFeedback = getAllFeedback();
    allFeedback.add(feedback);
    
    final List<Map<String, dynamic>> encodedFeedback = 
        allFeedback.map((item) => item.toJson()).toList();
    
    return await _storageService.saveString(_feedbackKey, jsonEncode(encodedFeedback));
  }

  // Get all feedback
  List<EventFeedback> getAllFeedback() {
    final String? feedbackJson = _storageService.getString(_feedbackKey);
    if (feedbackJson == null) return [];
    
    final List<dynamic> decodedFeedback = jsonDecode(feedbackJson);
    return decodedFeedback.map((feedback) => EventFeedback.fromJson(feedback)).toList();
  }
}
