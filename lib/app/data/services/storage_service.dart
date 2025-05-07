import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService extends GetxService {
  static const String tracksBoxName = 'tracks';
  static const String eventsBoxName = 'events';
  static const String subscribedEventsBoxName = 'subscribed_events';
  static const String feedbackBoxName = 'feedback';
  static const String metadataBoxName = 'metadata'; 


  String? getString(String key) {
    return Hive.box<String>('strings').get(key);
  }

  Future<bool> saveString(String key, String value) async {
    await Hive.box<String>('strings').put(key, value);
    return true;
  }

  List<String>? getStringList(String key) {
    return Hive.box<List<String>>('stringLists').get(key);
  }

  Future<bool> saveStringList(String key, List<String> value) async {
    await Hive.box<List<String>>('stringLists').put(key, value);
    return true;
  }

  Future<StorageService> init() async {
    if (!Hive.isBoxOpen('strings')) {
      await Hive.openBox<String>('strings');
    }
    if (!Hive.isBoxOpen('stringLists')) {
      await Hive.openBox<List<String>>('stringLists');
    }
    
    return this;
  }
}