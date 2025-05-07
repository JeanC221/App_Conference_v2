import 'dart:async';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionService extends GetxService {
  RxBool isOnline = false.obs; 
  late StreamSubscription<InternetConnectionStatus> _connectionSubscription;
  
  Future<bool> isConnected() async {
    return await InternetConnectionChecker().hasConnection;
  }
  
  Future<ConnectionService> init() async {
    isOnline.value = await isConnected();
    
    _connectionSubscription = InternetConnectionChecker()
        .onStatusChange
        .listen((status) {
          isOnline.value = status == InternetConnectionStatus.connected;
          print('Estado de conexión: ${isOnline.value ? "Online" : "Offline"}');
        });
    
    return this;
  }
  
  @override
  void onClose() {
    _connectionSubscription.cancel();
    super.onClose();
  }
}