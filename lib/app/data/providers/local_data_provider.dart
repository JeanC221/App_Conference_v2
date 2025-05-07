import 'dart:convert';
import 'package:get/get.dart';
import '../../domain/entities/event.dart';
import '../models/track_model.dart';
import '../services/storage_service.dart';
import 'package:hive/hive.dart';

class LocalDataProvider {
  final StorageService _storageService = Get.find<StorageService>();

  final List<Track> _sampleTracks = [
    Track(
      id: '1',
      name: 'Mobile Development',
      description: 'Sessions about mobile app development technologies and practices',
    ),
    Track(
      id: '2',
      name: 'Web Development',
      description: 'Latest trends and technologies in web development',
    ),
    Track(
      id: '3',
      name: 'AI & Machine Learning',
      description: 'Artificial intelligence and machine learning applications',
    ),
  ];

  final List<Event> _sampleEvents = [
  ];

  
Future<void> initializeIfEmpty() async {
  print('Inicializando datos de ejemplo de forma forzada...');
  
  try {
    final tracksBox = Hive.box<Track>('tracks');
    final eventsBox = Hive.box<Event>('events');
    
    await tracksBox.clear();
    await eventsBox.clear();
    
    print('Cajas limpiadas, agregando datos de ejemplo...');
    
    print('Agregando ${_sampleTracks.length} tracks de ejemplo...');
    for (var track in _sampleTracks) {
      await tracksBox.put(track.id, track);
    }
    
    print('Agregando ${_sampleEvents.length} eventos de ejemplo...');
    for (var event in _sampleEvents) {
      await eventsBox.put(event.id, event);
    }
    
    print('Verificando datos agregados:');
    print('Tracks: ${tracksBox.length}');
    print('Eventos: ${eventsBox.length}');
    
    if (tracksBox.length > 0) {
      print('Datos inicializados correctamente con Hive.');
    } else {
      await _initializeUsingSharedPreferences();
    }
  } catch (e) {
    print('Error al inicializar datos con Hive: $e');
    await _initializeUsingSharedPreferences();
  }
}
  
  Future<void> _initializeUsingSharedPreferences() async {
    print('Iniciando inicialización alternativa con SharedPreferences...');
    
    final tracksJson = _storageService.getString('tracks');
    if (tracksJson == null) {
      print('Inicializando tracks de ejemplo con SharedPreferences...');
      final List<Map<String, dynamic>> tracksList = _sampleTracks.map((t) => t.toJson()).toList();
      await _storageService.saveString('tracks', jsonEncode(tracksList));
    }
    
    final eventsJson = _storageService.getString('events');
    if (eventsJson == null) {
      print('Inicializando eventos de ejemplo con SharedPreferences...');
      final List<Map<String, dynamic>> eventsList = _sampleEvents.map((e) => e.toJson()).toList();
      await _storageService.saveString('events', jsonEncode(eventsList));
    }
    
    print('Datos inicializados correctamente con SharedPreferences.');
  }
  
}