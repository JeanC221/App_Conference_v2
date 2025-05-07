import '../entities/feedback.dart';

abstract class FeedbackRepository {
  Future<bool> submitFeedback(EventFeedback feedback);
  Future<List<EventFeedback>> getFeedbackForEvent(String eventId);
}