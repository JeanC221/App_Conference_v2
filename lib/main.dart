// lib/main.dart (actualizado)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize services
  await initializeServices();

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
    ),
  );
}

Future<void> initializeServices() async {
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => HttpService().init());
  await Get.putAsync(() => ConnectionService().init());

  Get.lazyPut<TrackRemoteDatasource>(() => TrackRemoteDatasource());
  Get.lazyPut<EventRemoteDatasource>(() => EventRemoteDatasource());
  Get.lazyPut<FeedbackRemoteDatasource>(() => FeedbackRemoteDatasource());
  
  Get.lazyPut<TrackLocalDatasource>(() => TrackLocalDatasource());
  Get.lazyPut<EventLocalDatasource>(() => EventLocalDatasource());
  Get.lazyPut<FeedbackLocalDatasource>(() => FeedbackLocalDatasource());
  
  Get.lazyPut<TrackRepository>(() => TrackRepositoryImpl());
  Get.lazyPut<EventRepository>(() => EventRepositoryImpl());
  Get.lazyPut<FeedbackRepository>(() => FeedbackRepositoryImpl());
}