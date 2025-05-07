import 'package:get/get.dart';
import '../../../data/services/web_service.dart';
import '../../../domain/entities/event.dart';

class EventRemoteDatasource {
  final HttpService _httpService = Get.find<HttpService>();
  final String _endpoint = '/events';

  Future<List<Event>> getEvents() async {
    try {
      final response = await _httpService.get(_endpoint);
      return (response.data as List)
          .map((json) => Event.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

  Future<List<Event>> getEventsByTrack(String trackId) async {
    try {
      final response = await _httpService.get('$_endpoint?trackId=$trackId');
      return (response.data as List)
          .map((json) => Event.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load events for track: $e');
    }
  }

  Future<Event> getEventById(String id) async {
    try {
      final response = await _httpService.get('$_endpoint/$id');
      return Event.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load event: $e');
    }
  }

  Future<bool> subscribeToEvent(String eventId) async {
    try {
      await _httpService.post('$_endpoint/$eventId/subscribe');
      return true;
    } catch (e) {
      throw Exception('Failed to subscribe to event: $e');
    }
  }

  Future<bool> unsubscribeFromEvent(String eventId) async {
    try {
      await _httpService.delete('$_endpoint/$eventId/subscribe');
      return true;
    } catch (e) {
      throw Exception('Failed to unsubscribe from event: $e');
    }
  }
}