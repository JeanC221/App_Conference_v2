import 'package:get/get.dart';
import '../controllers/subscribed_events_controller.dart';

class SubscribedEventsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscribedEventsController>(
      () => SubscribedEventsController(),
    );
  }
}
