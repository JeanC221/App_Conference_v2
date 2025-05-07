import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/data/providers/local_data_provider.dart';
import 'app/domain/entities/event.dart';
import 'app/domain/entities/feedback.dart';
import 'app/domain/entities/track.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/storage_service.dart';
import 'app/data/services/web_service.dart';
import 'app/data/services/connection_service.dart';
import 'app/data/datasources/remote/track_remote_datasource.dart';
import 'app/data/datasources/remote/event_remote_datasource.dart';
import 'app/data/datasources/remote/feedback_remote_datasource.dart';
import 'app/data/datasources/local/track_local_datasource.dart';
import 'app/data/datasources/local/event_local_datasource.dart';
import 'app/data/datasources/local/feedback_local_datasource.dart';
import 'app/data/repositories/track_repository_impl.dart';
import 'app/data/repositories/event_repository_impl.dart';
import 'app/data/repositories/feedback_repository_impl.dart';
import 'app/domain/repositories/track_repository.dart';
import 'app/domain/repositories/event_repository.dart';
import 'app/domain/repositories/feedback_repository.dart';
import 'app/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  FlutterError.onError = (FlutterErrorDetails details) {
    print('FlutterError: ${details.exception}');
    print('Stack trace: ${details.stack}');
    FlutterError.presentError(details);
  };
  
  try {
    print('Iniciando aplicación...');
    
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    print('Inicializando Hive...');
    await Hive.initFlutter();
    
    print('Registrando adaptadores...');
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TrackAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(EventAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(EventFeedbackAdapter());
    }
    
    print('Abriendo cajas de Hive...');
    if (!Hive.isBoxOpen('tracks')) {
      await Hive.openBox<Track>('tracks');
    }
    if (!Hive.isBoxOpen('events')) {
      await Hive.openBox<Event>('events');
    }
    if (!Hive.isBoxOpen('subscribed_events')) {
      await Hive.openBox<String>('subscribed_events');
    }
    if (!Hive.isBoxOpen('feedback')) {
      await Hive.openBox<EventFeedback>('feedback');
    }
    if (!Hive.isBoxOpen('strings')) {
      await Hive.openBox<String>('strings');
    }
    if (!Hive.isBoxOpen('stringLists')) {
      await Hive.openBox<List<String>>('stringLists');
    }
    
    print('Inicializando servicios...');
    final storageService = await StorageService().init();
    Get.put(storageService);
    
    final httpService = await HttpService().init();
    Get.put(httpService);
    
    final connectionService = await ConnectionService().init();
    Get.put(connectionService);
    
    print('Inicializando fuentes de datos...');
    Get.put(TrackLocalDatasource());
    Get.put(EventLocalDatasource());
    Get.put(FeedbackLocalDatasource());
    
    Get.put(TrackRemoteDatasource());
    Get.put(EventRemoteDatasource());
    Get.put(FeedbackRemoteDatasource());
    
    print('Inicializando repositorios...');
    Get.put<TrackRepository>(TrackRepositoryImpl());
    Get.put<EventRepository>(EventRepositoryImpl());
    Get.put<FeedbackRepository>(FeedbackRepositoryImpl());
    
    print('Inicializando datos de ejemplo...');
    final localDataProvider = LocalDataProvider();
    await localDataProvider.initializeIfEmpty();
    
    print('Iniciando aplicación...');
    runApp(
      GetMaterialApp(
        title: "Conference App",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
        onInit: () {
          print('GetMaterialApp initializado');
        },
      ),
    );
  } catch (e, stackTrace) {
    print('Error en la inicialización: $e');
    print('Stack trace: $stackTrace');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error al iniciar la aplicación:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text('$e', style: TextStyle(color: Colors.red)),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text('Cerrar aplicación'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> initializeServices() async {
  await Hive.initFlutter();
  
  Hive.registerAdapter(TrackAdapter());
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(EventFeedbackAdapter());
  
  await Hive.openBox<Track>('tracks');
  await Hive.openBox<Event>('events');
  await Hive.openBox<String>('subscribed_events');
  await Hive.openBox<EventFeedback>('feedback');
  await Hive.openBox<dynamic>('metadata');
  
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => HttpService().init());
  await Get.putAsync(() => ConnectionService().init());
  
  Get.put(TrackLocalDatasource());
  Get.put(EventLocalDatasource());
  Get.put(FeedbackLocalDatasource());
  
  Get.put(TrackRemoteDatasource());
  Get.put(EventRemoteDatasource());
  Get.put(FeedbackRemoteDatasource());
  
  Get.put<TrackRepository>(TrackRepositoryImpl(
    remoteDatasource: Get.find<TrackRemoteDatasource>(),
    localDatasource: Get.find<TrackLocalDatasource>(),
    connectionService: Get.find<ConnectionService>(),
  ));
  
  Get.put<EventRepository>(EventRepositoryImpl(
    remoteDatasource: Get.find<EventRemoteDatasource>(),
    localDatasource: Get.find<EventLocalDatasource>(),
    connectionService: Get.find<ConnectionService>(),
  ));
  
  Get.put<FeedbackRepository>(FeedbackRepositoryImpl(
    remoteDatasource: Get.find<FeedbackRemoteDatasource>(),
    localDatasource: Get.find<FeedbackLocalDatasource>(),
    connectionService: Get.find<ConnectionService>(),
  ));
}