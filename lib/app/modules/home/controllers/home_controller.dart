import 'package:get/get.dart';
import '../../../data/providers/local_data_provider.dart';
import '../../../data/models/event_model.dart';

class HomeController extends GetxController {
  final LocalDataProvider _localDataProvider = LocalDataProvider();
  
  final RxList<Event> upcomingEvents = <Event>[].obs;
  final RxList<String> subscribedEventIds = <String>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _localDataProvider.initializeIfEmpty();
    _loadUpcomingEvents();
    _loadSubscribedEvents();
  }
  
  void _loadUpcomingEvents() {
    final allEvents = _localDataProvider.getEvents();
    upcomingEvents.value = allEvents
        .where((event) => !event.isPast)
        .take(5)
        .toList();
  }
  
  void _loadSubscribedEvents() {
    subscribedEventIds.value = _localDataProvider.getSubscribedEventIds();
  }
  
  bool isSubscribed(String eventId) {
    return subscribedEventIds.contains(eventId);
  }

  void navigateToEventTracks() {
    Get.toNamed('/event-tracks');
  }

  void navigateToSubscribedEvents() {
    Get.toNamed('/subscribed-events');
  }
  
  void navigateToEventDetails(Event event) {
    Get.toNamed('/event-details', arguments: {
      'eventId': event.id,
      'trackId': event.trackId,
    });
  }
}
