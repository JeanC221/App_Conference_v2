import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../domain/entities/track.dart';
import '../../services/storage_service.dart';

class TrackLocalDatasource {
  Box<Track> get _tracksBox => Hive.box<Track>('tracks');
  
  Future<void> saveTracks(List<Track> tracks) async {
    print('Guardando ${tracks.length} tracks en local...');
    final Map<String, Track> tracksMap = {
      for (var track in tracks) track.id: track
    };
    await _tracksBox.putAll(tracksMap);
  }
  
  List<Track> getTracks() {
    final tracks = _tracksBox.values.toList();
    print('Obteniendo ${tracks.length} tracks desde local.');
    
    // Si está vacío, agrega algunos tracks de ejemplo directamente
    if (tracks.isEmpty) {
      print('No hay tracks en local, intentando agregar algunos de ejemplo...');
      _addSampleTracks();
      return _tracksBox.values.toList();
    }
    
    return tracks;
  }
  
  void _addSampleTracks() {
    try {
      final sampleTracks = [
        Track(
          id: '1',
          name: 'Mobile Development',
          description: 'Sessions about mobile app development technologies and practices',
        ),
        Track(
          id: '2',
          name: 'Web Development',
          description: 'Latest trends and technologies in web development',
        ),
        Track(
          id: '3',
          name: 'AI & Machine Learning',
          description: 'Artificial intelligence and machine learning applications',
        ),
      ];
      
      for (var track in sampleTracks) {
        _tracksBox.put(track.id, track);
      }
      
      print('Tracks de ejemplo agregados directamente: ${_tracksBox.length}');
    } catch (e) {
      print('Error al agregar tracks de ejemplo: $e');
    }
  }
  
  Track getTrackById(String id) {
    var track = _tracksBox.get(id);
    
    // Si no existe el track, intentamos cargar los ejemplos
    if (track == null) {
      print('Track con ID $id no encontrado, intentando cargar ejemplos...');
      _addSampleTracks();
      track = _tracksBox.get(id);
    }
    
    print('Obteniendo track: ${track?.name}');
    return track!;
  }
}