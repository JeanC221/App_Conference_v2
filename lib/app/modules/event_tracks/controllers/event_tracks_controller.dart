import 'package:get/get.dart';
import '../../../domain/entities/track.dart';
import '../../../domain/repositories/track_repository.dart';
import '../../../domain/repositories/event_repository.dart';
import '../../../data/services/connection_service.dart';

class EventTracksController extends GetxController {
  final TrackRepository _trackRepository = Get.find<TrackRepository>();
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final ConnectionService _connectionService = Get.find<ConnectionService>();
  
  final RxList<Track> tracks = <Track>[].obs;
  final RxBool isLoading = true.obs;
  final RxMap<String, int> eventCounts = <String, int>{}.obs;
  final RxBool isOnline = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    isOnline.value = _connectionService.isOnline.value;
    _connectionService.isOnline.listen((value) {
      isOnline.value = value;
      if (value) {
        // Refrescar datos cuando se recupere la conexión
        loadTracks();
      }
    });
    loadTracks();
  }
  
 // lib/app/modules/event_tracks/controllers/event_tracks_controller.dart
void loadTracks() async {
  isLoading.value = true;
  
  try {
    print('Cargando tracks...');
    // Obtener tracks
    tracks.value = await _trackRepository.getTracks();
    print('Tracks cargados: ${tracks.length}');
    
    // Contar eventos para cada track
    for (final track in tracks) {
      print('Cargando eventos para track: ${track.id}');
      final events = await _eventRepository.getEventsByTrack(track.id);
      eventCounts[track.id] = events.length;
      print('Eventos cargados para track ${track.id}: ${events.length}');
    }
  } catch (e, stackTrace) {
    print('Error al cargar tracks: $e');
    print('Stack trace: $stackTrace');
    Get.snackbar(
      'Error',
      'Failed to load tracks. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isLoading.value = false;
  }
}
  
  int getEventCountForTrack(String trackId) {
    return eventCounts[trackId] ?? 0;
  }
  
  void navigateToTrackEvents(String trackId, String trackName) {
    Get.toNamed('/event-details', arguments: {'trackId': trackId, 'trackName': trackName});
  }
}