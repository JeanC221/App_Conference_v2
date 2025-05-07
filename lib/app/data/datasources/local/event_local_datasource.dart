import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../domain/entities/event.dart';
import '../../services/storage_service.dart';

class EventLocalDatasource {
  Box<Event> get _eventsBox => 
      Hive.box<Event>(StorageService.eventsBoxName);
  
  Box<String> get _subscribedEventsBox => 
      Hive.box<String>(StorageService.subscribedEventsBoxName);
  
  Future<void> saveEvents(List<Event> events) async {
    final Map<String, Event> eventsMap = {
      for (var event in events) event.id: event
    };
    await _eventsBox.putAll(eventsMap);
  }
  
  List<Event> getEvents() {
    final events = _eventsBox.values.toList();
    
    // Si no hay eventos, agregar eventos de ejemplo
    if (events.isEmpty) {
      print('No hay eventos en local, agregando ejemplos...');
      _addSampleEvents();
      return _eventsBox.values.toList();
    }
    
    return events;
  }
  
  List<Event> getEventsByTrack(String trackId) {
    var events = _eventsBox.values
        .where((event) => event.trackId == trackId)
        .toList();
    
    // Si no hay eventos para este track, agregar ejemplos
    if (events.isEmpty) {
      print('No hay eventos para el track $trackId, agregando ejemplos...');
      _addSampleEventsForTrack(trackId);
      events = _eventsBox.values
          .where((event) => event.trackId == trackId)
          .toList();
    }
    
    print('Eventos cargados para track $trackId: ${events.length}');
    return events;
  }
  
  Event getEventById(String id) {
    var event = _eventsBox.get(id);
    
    // Si no existe el evento, cargar los eventos de ejemplo
    if (event == null) {
      print('Evento con ID $id no encontrado, cargando ejemplos...');
      _addSampleEvents();
      event = _eventsBox.get(id);
    }
    
    return event!;
  }
  
  void _addSampleEvents() {
    // Añadir eventos para los 3 tracks
    _addSampleEventsForTrack('1'); // Mobile Development
    _addSampleEventsForTrack('2'); // Web Development
    _addSampleEventsForTrack('3'); // AI & Machine Learning
  }
  
  void _addSampleEventsForTrack(String trackId) {
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));
    final yesterday = now.subtract(Duration(days: 1));
    final nextWeek = now.add(Duration(days: 7));
    
    List<Event> eventsToAdd = [];
    
    switch (trackId) {
      case '1': // Mobile Development
        eventsToAdd = [
          Event(
            id: '101',
            name: 'Flutter para Principiantes',
            location: 'Sala A - Edificio Principal',
            dateTime: tomorrow,
            maxParticipants: 50,
            currentParticipants: 25,
            description: 'Introducción a Flutter para desarrollo móvil multiplataforma. Aprenderás los fundamentos, widgets básicos y navegación entre pantallas.',
            trackId: '1',
            averageRating: 4.5,
          ),
          Event(
            id: '102',
            name: 'Desarrollo Avanzado en Swift',
            location: 'Sala B - Edificio Principal',
            dateTime: nextWeek,
            maxParticipants: 30,
            currentParticipants: 28,
            description: 'Taller avanzado de Swift para iOS, cubriendo patrones de diseño, concurrencia y SwiftUI.',
            trackId: '1',
          ),
          Event(
            id: '103',
            name: 'Kotlin para Android: Lo nuevo en 2025',
            location: 'Auditorio Central',
            dateTime: yesterday,
            maxParticipants: 100,
            currentParticipants: 95,
            description: 'Eventos pasado sobre las nuevas características de Kotlin para desarrollo Android en 2025.',
            trackId: '1',
            averageRating: 4.2,
          ),
        ];
        break;
        
      case '2': // Web Development
        eventsToAdd = [
          Event(
            id: '201',
            name: 'React vs Angular en 2025',
            location: 'Sala C - Edificio Tecnológico',
            dateTime: tomorrow,
            maxParticipants: 80,
            currentParticipants: 50,
            description: 'Comparativa actualizada entre los frameworks más populares: React y Angular. Ventajas, desventajas y casos de uso.',
            trackId: '2',
          ),
          Event(
            id: '202',
            name: 'Optimización de Rendimiento Web',
            location: 'Laboratorio 1',
            dateTime: nextWeek.add(Duration(days: 1)),
            maxParticipants: 40,
            currentParticipants: 15,
            description: 'Técnicas avanzadas para optimización de rendimiento web, incluyendo lazy loading, minificación y estrategias de caching.',
            trackId: '2',
          ),
          Event(
            id: '203',
            name: 'Introducción a WebAssembly',
            location: 'Sala D - Edificio Tecnológico',
            dateTime: yesterday.subtract(Duration(days: 2)),
            maxParticipants: 60,
            currentParticipants: 58,
            description: 'Evento pasado donde se cubrieron los conceptos básicos de WebAssembly y cómo implementarlo en proyectos web.',
            trackId: '2',
            averageRating: 4.8,
          ),
        ];
        break;
        
      case '3': // AI & Machine Learning
        eventsToAdd = [
          Event(
            id: '301',
            name: 'Introducción a TensorFlow 3.0',
            location: 'Centro de Computación Avanzada',
            dateTime: tomorrow.add(Duration(days: 2)),
            maxParticipants: 70,
            currentParticipants: 65,
            description: 'Introducción a las nuevas características de TensorFlow 3.0 con ejemplos prácticos y casos de uso reales.',
            trackId: '3',
          ),
          Event(
            id: '302',
            name: 'Ética en Inteligencia Artificial',
            location: 'Auditorio Central',
            dateTime: nextWeek.add(Duration(days: 3)),
            maxParticipants: 120,
            currentParticipants: 40,
            description: 'Panel de discusión sobre los dilemas éticos en el desarrollo e implementación de sistemas de IA en diversos contextos.',
            trackId: '3',
          ),
          Event(
            id: '303',
            name: 'Machine Learning para Principiantes',
            location: 'Laboratorio de IA',
            dateTime: yesterday.subtract(Duration(days: 1)),
            maxParticipants: 50,
            currentParticipants: 50,
            description: 'Evento pasado que cubrió los fundamentos de Machine Learning para personas sin experiencia previa en el campo.',
            trackId: '3',
            averageRating: 4.6,
          ),
        ];
        break;
    }
    
    // Guardar los eventos en la base de datos
    for (var event in eventsToAdd) {
      _eventsBox.put(event.id, event);
    }
    
    print('Agregados ${eventsToAdd.length} eventos para el track $trackId');
  }
  
  Future<void> subscribeToEvent(String eventId) async {
    await _subscribedEventsBox.put(eventId, eventId);
  }
  
  Future<void> unsubscribeFromEvent(String eventId) async {
    await _subscribedEventsBox.delete(eventId);
  }
  
  bool isSubscribedToEvent(String eventId) {
    return _subscribedEventsBox.containsKey(eventId);
  }
  
  List<Event> getSubscribedEvents() {
    final subscribedIds = _subscribedEventsBox.values.toList();
    return _eventsBox.values
        .where((event) => subscribedIds.contains(event.id))
        .toList();
  }
}