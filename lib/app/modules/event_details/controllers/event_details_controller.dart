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

  @override
  void onInit() {
    super.onInit();
    
    print('EventDetailsController onInit con args: ${Get.arguments}');
    final Map<String, dynamic>? args = Get.arguments;
    if (args != null) {
      if (args.containsKey('trackId')) {
        final String trackId = args['trackId'];
        print('Cargando eventos para track: $trackId');
        loadTrackEvents(trackId);
      } else if (args.containsKey('eventId')) {
        selectedEventId.value = args['eventId'];
        print('Cargando detalles para evento: ${selectedEventId.value}');
        loadEventDetails();
      }
    } else {
      print('Error: No se recibieron argumentos para EventDetailsController');
      isLoading.value = false;
    }
  }

  void loadTrackEvents(String trackId) async {
    isLoading.value = true;
    try {
      print('Obteniendo track con ID: $trackId');
      track.value = await _trackRepository.getTrackById(trackId);
      print('Track obtenido: ${track.value?.name}');
      
      print('Cargando eventos del track...');
      events.value = await _eventRepository.getEventsByTrack(trackId);
      print('Eventos cargados: ${events.length}');
      
      selectedEvent.value = null;
    } catch (e, stackTrace) {
      print('Error al cargar eventos del track: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'No se pudieron cargar los eventos. Inténtalo de nuevo.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loadEventDetails() async {
    if (selectedEventId.value.isEmpty) return;

    try {
      isLoading.value = true;
      final allEvents = await _eventRepository.getEvents();
      selectedEvent.value = allEvents.firstWhereOrNull(
        (e) => e.id == selectedEventId.value,
      );

      if (selectedEvent.value != null) {
        track.value = await _trackRepository.getTrackById(selectedEvent.value!.trackId);
        isSubscribed.value = await _eventRepository.isSubscribedToEvent(selectedEvent.value!.id);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cargar los detalles del evento',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
          _showSnackbar('Éxito', 'Te has dado de baja del evento');
        }
      } else {
        success = await _eventRepository.subscribeToEvent(eventId);
        if (success) {
          isSubscribed.value = true;
          _showSnackbar('Éxito', 'Te has suscrito al evento');
        }
      }
    } catch (e) {
      _showSnackbar('Error', 'No se pudo actualizar la suscripción');
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
        'Por favor proporciona una calificación',
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
          'Éxito',
          'Comentario enviado',
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
        'No se pudo enviar el comentario',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    }
  }
}