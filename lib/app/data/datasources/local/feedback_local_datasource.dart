import 'package:hive/hive.dart';
import '../../../domain/entities/feedback.dart';
import '../../services/storage_service.dart';

class FeedbackLocalDatasource {
  Box<EventFeedback> get _feedbackBox => 
      Hive.box<EventFeedback>(StorageService.feedbackBoxName);
  
  Future<void> saveFeedback(EventFeedback feedback) async {
    // Usamos DateTime como parte de la clave para evitar conflictos
    final key = '${feedback.eventId}_${feedback.submittedAt.millisecondsSinceEpoch}';
    await _feedbackBox.put(key, feedback);
  }
  
  List<EventFeedback> getFeedbackForEvent(String eventId) {
    return _feedbackBox.values
        .where((feedback) => feedback.eventId == eventId)
        .toList();
  }
}