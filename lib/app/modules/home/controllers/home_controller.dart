import 'package:get/get.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/repositories/event_repository.dart';
import '../../../data/services/connection_service.dart';

class HomeController extends GetxController {
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final ConnectionService _connectionService = Get.find<ConnectionService>();
  
  final RxList<Event> upcomingEvents = <Event>[].obs;
  final RxList<String> subscribedEventIds = <String>[].obs;
  final RxBool isOnline = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    isOnline.value = _connectionService.isOnline.value;
    _connectionService.isOnline.listen((value) {
      isOnline.value = value;
      if (value) {
        _loadData();
      }
    });
    
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUpcomingEvents();
    await _loadSubscribedEvents();
  }
  
  Future<void> _loadUpcomingEvents() async {
    try {
      final allEvents = await _eventRepository.getEvents();
      upcomingEvents.value = allEvents
          .where((event) => !event.isPast)
          .take(5)
          .toList();
    } catch (e) {
      // Manejar error
    }
  }
  
  Future<void> _loadSubscribedEvents() async {
    try {
      final subscribedEvents = await _eventRepository.getSubscribedEvents();
      subscribedEventIds.value = subscribedEvents.map((e) => e.id).toList();
    } catch (e) {
      // Manejar error
    }
  }
  
  Future<bool> isSubscribed(String eventId) async {
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