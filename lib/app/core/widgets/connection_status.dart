import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/connection_service.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConnectionService connectionService = Get.find<ConnectionService>();
    
    return Obx(() {
      final bool isOnline = connectionService.isOnline.value;
      
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isOnline ? 0 : 30,
        width: double.infinity,
        color: Colors.red,
        child: isOnline 
            ? const SizedBox() 
            : const Center(
                child: Text(
                  'No internet connection - Working offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      );
    });
  }
}