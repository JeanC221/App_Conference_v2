// lib/app/modules/subscribed_events/controllers/subscribed_events_controller.dart (actualizado)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/repositories/event_repository.dart';
import '../../../data/services/connection_service.dart';

class SubscribedEventsController extends GetxController {
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final ConnectionService _connectionService = Get.find<ConnectionService>();

  final RxList<Event> subscribedEvents = <Event>[].obs;
  final RxList<Event> upcomingEvents = <Event>[].obs;
  final RxList<Event> pastEvents = <Event>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isOnline = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    isOnline.value = _connectionService.isOnline.value;
    _connectionService.isOnline.listen((value) {
      isOnline.value = value;
      if (value) {
        // Refrescar datos cuando se recupere la conexión
        loadSubscribedEvents();
      }
    });
    
    loadSubscribedEvents();
  }

  void loadSubscribedEvents() async {
    try {
      isLoading.value = true;

      // Obtener eventos suscritos
      final events = await _eventRepository.getSubscribedEvents();
      subscribedEvents.value = events;

      // Separar en próximos y pasados
      upcomingEvents.value = events.where((event) => !event.isPast).toList();
      pastEvents.value = events.where((event) => event.isPast).toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load subscribed events. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToEventDetails(Event event) {
    Get.toNamed('/event-details', arguments: {
      'eventId': event.id,
      'trackId': event.trackId,
    });
  }

  Future<void> unsubscribeFromEvent(String eventId) async {
    try {
      await _eventRepository.unsubscribeFromEvent(eventId);
      loadSubscribedEvents();

      Get.snackbar(
        'Success',
        'You have successfully unsubscribed from the event.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to unsubscribe from the event. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
      );
    }
  }
}