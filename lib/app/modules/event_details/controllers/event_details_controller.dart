import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/track.dart';
import '../../../domain/entities/feedback.dart';
import '../../../domain/repositories/event_repository.dart';
import '../../../domain/repositories/track_repository.dart';
import '../../../domain/repositories/feedback_repository.dart';
import '../../../core/theme/app_theme.dart';

class EventDetailsController extends GetxController {
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final TrackRepository _trackRepository = Get.find<TrackRepository>();
  final FeedbackRepository _feedbackRepository = Get.find<FeedbackRepository>();

  final RxList<Event> events = <Event>[].obs;
  final Rx<Track?> track = Rx<Track?>(null);
  final RxBool isLoading = true.obs;

  final RxString selectedEventId = ''.obs;
  final Rx<Event?> selectedEvent = Rx<Event?>(null);
  final RxBool isSubscribed = false.obs;

  final TextEditingController feedbackController = TextEditingController();
  final RxDouble rating = 0.0.obs;

  void loadEventDetails() async {
    if (selectedEventId.value.isEmpty) return;

    try {
      final allEvents = await _eventRepository.getEvents();
      selectedEvent.value = allEvents.firstWhereOrNull(
        (e) => e.id == selectedEventId.value,
      );

      if (selectedEvent.value != null) {
        isSubscribed.value = await _eventRepository.isSubscribedToEvent(selectedEvent.value!.id);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load event details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    }
  }

  void selectEvent(Event event) {
    selectedEventId.value = event.id;
    selectedEvent.value = event;
    _checkSubscriptionStatus();
  }

  Future<void> _checkSubscriptionStatus() async {
    if (selectedEvent.value == null) return;
    isSubscribed.value = await _eventRepository.isSubscribedToEvent(selectedEvent.value!.id);
  }

  Future<void> toggleSubscription() async {
    if (selectedEvent.value == null) return;

    final eventId = selectedEvent.value!.id;
    bool success;

    try {
      if (isSubscribed.value) {
        success = await _eventRepository.unsubscribeFromEvent(eventId);
        if (success) {
          isSubscribed.value = false;
          _showSnackbar('Success', 'Unsubscribed from event');
        }
      } else {
        success = await _eventRepository.subscribeToEvent(eventId);
        if (success) {
          isSubscribed.value = true;
          _showSnackbar('Success', 'Subscribed to event');
        }
      }
    } catch (e) {
      _showSnackbar('Error', 'Failed to update subscription');
    }
  }

  void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
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
  }

  Future<void> submitFeedback() async {
    if (selectedEvent.value == null) return;
    if (rating.value == 0) {
      Get.snackbar(
        'Error',
        'Please provide a rating',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
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
      return;
    }

    final feedback = EventFeedback(
      eventId: selectedEvent.value!.id,
      feedback: feedbackController.text.trim(),
      rating: rating.value,
      submittedAt: DateTime.now(),
    );

    try {
      final success = await _feedbackRepository.submitFeedback(feedback);
      if (success) {
        feedbackController.clear();
        rating.value = 0;
        Get.snackbar(
          'Success',
          'Feedback submitted',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.successColor,
          colorText: Colors.white,
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
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit feedback',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    }
  }
}