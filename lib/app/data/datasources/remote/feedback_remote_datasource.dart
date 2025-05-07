import 'package:get/get.dart';
import '../../../data/services/web_service.dart';
import '../../../domain/entities/feedback.dart';

class FeedbackRemoteDatasource {
  final HttpService _httpService = Get.find<HttpService>();
  final String _endpoint = '/feedback';

  Future<bool> submitFeedback(EventFeedback feedback) async {
    try {
      await _httpService.post(_endpoint, data: feedback.toJson());
      return true;
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }

  Future<List<EventFeedback>> getFeedbackForEvent(String eventId) async {
    try {
      final response = await _httpService.get('$_endpoint?eventId=$eventId');
      return (response.data as List)
          .map((json) => EventFeedback.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load feedback: $e');
    }
  }
}