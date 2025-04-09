import 'package:get/get.dart';
import '../../../data/models/track_model.dart';
import '../../../data/providers/local_data_provider.dart';

class EventTracksController extends GetxController {
  final LocalDataProvider _localDataProvider = LocalDataProvider();
  
  final RxList<Track> tracks = <Track>[].obs;
  final RxBool isLoading = true.obs;
  final RxMap<String, int> eventCounts = <String, int>{}.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadTracks();
  }
  
  void loadTracks() {
    isLoading.value = true;
    
    // Get tracks
    tracks.value = _localDataProvider.getTracks();
    
    // Count events for each track
    final allEvents = _localDataProvider.getEvents();
    for (final track in tracks) {
      final count = allEvents.where((event) => event.trackId == track.id).length;
      eventCounts[track.id] = count;
    }
    
    isLoading.value = false;
  }
  
  int getEventCountForTrack(String trackId) {
    return eventCounts[trackId] ?? 0;
  }
  
  void navigateToTrackEvents(String trackId, String trackName) {
    Get.toNamed('/event-details', arguments: {'trackId': trackId, 'trackName': trackName});
  }
}
