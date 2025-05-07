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
  
  void loadTracks() async {
    isLoading.value = true;
    
    try {
      // Obtener tracks
      tracks.value = await _trackRepository.getTracks();
      
      // Contar eventos para cada track
      for (final track in tracks) {
        final events = await _eventRepository.getEventsByTrack(track.id);
        eventCounts[track.id] = events.length;
      }
    } catch (e) {
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