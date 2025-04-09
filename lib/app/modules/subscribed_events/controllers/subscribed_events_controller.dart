import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/providers/local_data_provider.dart';

class SubscribedEventsController extends GetxController {
  final LocalDataProvider _localDataProvider = LocalDataProvider();

  final RxList<Event> subscribedEvents = <Event>[].obs;
  final RxList<Event> upcomingEvents = <Event>[].obs;
  final RxList<Event> pastEvents = <Event>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSubscribedEvents();
  }

  void loadSubscribedEvents() async {
    try {
      isLoading.value = true;

      // Fetch all subscribed events
      final events = _localDataProvider.getSubscribedEvents();
      subscribedEvents.value = events;

      // Separate into upcoming and past events
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
      await _localDataProvider.unsubscribeFromEvent(eventId);
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
