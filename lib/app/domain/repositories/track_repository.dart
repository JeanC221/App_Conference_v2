import '../entities/track.dart';

abstract class TrackRepository {
  Future<List<Track>> getTracks();
  Future<Track> getTrackById(String id);
}