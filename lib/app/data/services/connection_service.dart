import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionService extends GetxService {
  Future<bool> isConnected() async {
    return await InternetConnectionChecker().hasConnection;
  }
  
  RxBool isOnline = false.obs;
  
  Future<ConnectionService> init() async {
    // Verificar conectividad inicial
    isOnline.value = await isConnected();
    
    // Escuchar cambios en la conectividad
    InternetConnectionChecker().onStatusChange.listen((status) {
      isOnline.value = status == InternetConnectionStatus.connected;
    });
    
    return this;
  }
}