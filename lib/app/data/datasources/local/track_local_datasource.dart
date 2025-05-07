import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../domain/entities/track.dart';
import '../../services/storage_service.dart';

class TrackLocalDatasource {
  Box<Track> get _tracksBox => 
      Hive.box<Track>(StorageService.tracksBoxName);
  
  Future<void> saveTracks(List<Track> tracks) async {
    final Map<String, Track> tracksMap = {
      for (var track in tracks) track.id: track
    };
    await _tracksBox.putAll(tracksMap);
  }
  
  List<Track> getTracks() {
    return _tracksBox.values.toList();
  }
  
  Track getTrackById(String id) {
    return _tracksBox.get(id)!;
  }
}