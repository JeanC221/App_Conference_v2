import '../../domain/repositories/track_repository.dart';
import '../../domain/entities/track.dart';
import '../datasources/remote/track_remote_datasource.dart';
import '../datasources/local/track_local_datasource.dart';
import '../services/connection_service.dart';

class TrackRepositoryImpl implements TrackRepository {
  final TrackRemoteDatasource _remoteDatasource;
  final TrackLocalDatasource _localDatasource;
  final ConnectionService _connectionService;

  TrackRepositoryImpl({
    required TrackRemoteDatasource remoteDatasource,
    required TrackLocalDatasource localDatasource,
    required ConnectionService connectionService,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource,
        _connectionService = connectionService;

  @override
  Future<List<Track>> getTracks() async {
    if (await _connectionService.isConnected()) {
      try {
        final tracks = await _remoteDatasource.getTracks();
        await _localDatasource.saveTracks(tracks);
        return tracks;
      } catch (e) {
        return _localDatasource.getTracks();
      }
    } else {
      return _localDatasource.getTracks();
    }
  }

  @override
  Future<Track> getTrackById(String id) async {
    if (await _connectionService.isConnected()) {
      try {
        final track = await _remoteDatasource.getTrackById(id);
        return track;
      } catch (e) {
        return _localDatasource.getTrackById(id);
      }
    } else {
      return _localDatasource.getTrackById(id);
    }
  }
}