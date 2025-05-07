import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionService extends GetxService {
  RxBool isOnline = true.obs; 
  
  Future<bool> isConnected() async {
    return true; 
  }
  
  Future<ConnectionService> init() async {
    isOnline.value = true;
    return this;
  }
}