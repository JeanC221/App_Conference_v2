import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../domain/entities/event.dart';
import '../../services/storage_service.dart';

class EventLocalDatasource {
  Box<Event> get _eventsBox => 
      Hive.box<Event>(StorageService.eventsBoxName);
  
  Box<String> get _subscribedEventsBox => 
      Hive.box<String>(StorageService.subscribedEventsBoxName);
  
  Future<void> saveEvents(List<Event> events) async {
    final Map<String, Event> eventsMap = {
      for (var event in events) event.id: event
    };
    await _eventsBox.putAll(eventsMap);
  }
  
  List<Event> getEvents() {
    return _eventsBox.values.toList();
  }
  
  List<Event> getEventsByTrack(String trackId) {
    return _eventsBox.values
        .where((event) => event.trackId == trackId)
        .toList();
  }
  
  Event getEventById(String id) {
    return _eventsBox.get(id)!;
  }
  
  Future<void> subscribeToEvent(String eventId) async {
    await _subscribedEventsBox.put(eventId, eventId);
  }
  
  Future<void> unsubscribeFromEvent(String eventId) async {
    await _subscribedEventsBox.delete(eventId);
  }
  
  bool isSubscribedToEvent(String eventId) {
    return _subscribedEventsBox.containsKey(eventId);
  }
  
  List<Event> getSubscribedEvents() {
    final subscribedIds = _subscribedEventsBox.values.toList();
    return _eventsBox.values
        .where((event) => subscribedIds.contains(event.id))
        .toList();
  }
}