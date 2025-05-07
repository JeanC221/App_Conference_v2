import '../../domain/repositories/event_repository.dart';
import '../../domain/entities/event.dart';
import '../datasources/remote/event_remote_datasource.dart';
import '../datasources/local/event_local_datasource.dart';
import '../services/connection_service.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDatasource _remoteDatasource;
  final EventLocalDatasource _localDatasource;
  final ConnectionService _connectionService;

  EventRepositoryImpl({
    required EventRemoteDatasource remoteDatasource,
    required EventLocalDatasource localDatasource,
    required ConnectionService connectionService,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource,
        _connectionService = connectionService;

  @override
  Future<List<Event>> getEvents() async {
    if (await _connectionService.isConnected()) {
      try {
        final events = await _remoteDatasource.getEvents();
        // Guarda los datos remotos localmente
        await _localDatasource.saveEvents(events);
        return events;
      } catch (e) {
        print('Error obteniendo eventos remotos: $e');
        // Si falla, usa datos locales
        return _localDatasource.getEvents();
      }
    } else {
      // Sin conexión: usa datos locales
      return _localDatasource.getEvents();
    }
  }

  @override
  Future<List<Event>> getEventsByTrack(String trackId) async {
    if (await _connectionService.isConnected()) {
      try {
        final events = await _remoteDatasource.getEventsByTrack(trackId);
        // Guarda los datos en caché
        await _localDatasource.saveEvents(events);
        return events;
      } catch (e) {
        print('Error obteniendo eventos por track: $e');
        return _localDatasource.getEventsByTrack(trackId);
      }
    } else {
      return _localDatasource.getEventsByTrack(trackId);
    }
  }

  @override
  Future<Event> getEventById(String id) async {
    if (await _connectionService.isConnected()) {
      try {
        final event = await _remoteDatasource.getEventById(id);
        return event;
      } catch (e) {
        return _localDatasource.getEventById(id);
      }
    } else {
      return _localDatasource.getEventById(id);
    }
  }

  @override
  Future<bool> subscribeToEvent(String eventId) async {
    if (await _connectionService.isConnected()) {
      try {
        final success = await _remoteDatasource.subscribeToEvent(eventId);
        if (success) {
          // Actualiza los datos locales
          await _localDatasource.subscribeToEvent(eventId);
        }
        return success;
      } catch (e) {
        // En caso de error, guarda localmente pero marca para sincronización posterior
        await _localDatasource.subscribeToEvent(eventId);
        // Aquí se podría implementar una cola de sincronización
        return true;
      }
    } else {
      // Modo offline: guarda localmente
      await _localDatasource.subscribeToEvent(eventId);
      return true;
    }
  }

  @override
  Future<bool> unsubscribeFromEvent(String eventId) async {
    if (await _connectionService.isConnected()) {
      try {
        final success = await _remoteDatasource.unsubscribeFromEvent(eventId);
        if (success) {
          await _localDatasource.unsubscribeFromEvent(eventId);
        }
        return success;
      } catch (e) {
        await _localDatasource.unsubscribeFromEvent(eventId);
        return true;
      }
    } else {
      await _localDatasource.unsubscribeFromEvent(eventId);
      return true;
    }
  }

  @override
  Future<List<Event>> getSubscribedEvents() async {
    return _localDatasource.getSubscribedEvents();
  }

  @override
  Future<bool> isSubscribedToEvent(String eventId) async {
    return _localDatasource.isSubscribedToEvent(eventId);
  }
}