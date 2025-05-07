import '../entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> getEvents();
  Future<List<Event>> getEventsByTrack(String trackId);
  Future<Event> getEventById(String id);
  Future<bool> subscribeToEvent(String eventId);
  Future<bool> unsubscribeFromEvent(String eventId);
  Future<List<Event>> getSubscribedEvents();
  Future<bool> isSubscribedToEvent(String eventId);
}