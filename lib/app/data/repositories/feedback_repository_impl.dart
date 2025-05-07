import '../../domain/repositories/feedback_repository.dart';
import '../../domain/entities/feedback.dart';
import '../datasources/remote/feedback_remote_datasource.dart';
import '../datasources/local/feedback_local_datasource.dart';
import '../services/connection_service.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDatasource _remoteDatasource;
  final FeedbackLocalDatasource _localDatasource;
  final ConnectionService _connectionService;

  FeedbackRepositoryImpl({
    required FeedbackRemoteDatasource remoteDatasource,
    required FeedbackLocalDatasource localDatasource,
    required ConnectionService connectionService,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource,
        _connectionService = connectionService;

  @override
  Future<bool> submitFeedback(EventFeedback feedback) async {
    if (await _connectionService.isConnected()) {
      try {
        final success = await _remoteDatasource.submitFeedback(feedback);
        if (success) {
          await _localDatasource.saveFeedback(feedback);
        }
        return success;
      } catch (e) {
        await _localDatasource.saveFeedback(feedback);
        return true;
      }
    } else {
      await _localDatasource.saveFeedback(feedback);
      return true;
    }
  }

  @override
  Future<List<EventFeedback>> getFeedbackForEvent(String eventId) async {
    if (await _connectionService.isConnected()) {
      try {
        final feedback = await _remoteDatasource.getFeedbackForEvent(eventId);
        return feedback;
      } catch (e) {
        return _localDatasource.getFeedbackForEvent(eventId);
      }
    } else {
      return _localDatasource.getFeedbackForEvent(eventId);
    }
  }
}