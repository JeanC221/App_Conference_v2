import 'package:get/get.dart';
import '../controllers/event_tracks_controller.dart';

class EventTracksBinding extends Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut<EventTracksController>(
      () => EventTracksController(),
    );
  }
}