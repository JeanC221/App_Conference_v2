import 'package:conference_app/app/data/services/connection_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:conference_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Test', () {
    testWidgets('Full app journey test', (WidgetTester tester) async {
      // Iniciar la aplicación
      app.main();
      await tester.pumpAndSettle();

      // Verificar que estamos en la pantalla de inicio
      expect(find.text('Conference App'), findsOneWidget);
      
      // Verificar elementos de la pantalla de inicio
      expect(find.text('Upcoming Events'), findsOneWidget);
      expect(find.text('Quick Access'), findsOneWidget);
      
      // Navegar a Event Tracks
      await tester.tap(find.text('View All'));
      await tester.pumpAndSettle();
      
      // Verificar que estamos en Event Tracks
      expect(find.text('Event Tracks'), findsOneWidget);
      
      // Verificar que se cargaron los tracks
      expect(find.byType(Card), findsWidgets);
      
      // Tocar el primer track para ver sus eventos
      await tester.tap(find.text('View Events').first);
      await tester.pumpAndSettle();
      
      // Verificar que se cargaron los eventos del track
      await tester.pumpAndSettle(Duration(seconds: 2)); // Dar tiempo para cargar
      expect(find.byType(Card), findsWidgets);
      
      // Volver a la pantalla anterior
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();
      
      // Navegar a Subscribed Events desde el bottomNavigationBar
      await tester.tap(find.text('My Events'));
      await tester.pumpAndSettle();
      
      // Verificar que estamos en Subscribed Events
      expect(find.text('My Subscribed Events'), findsOneWidget);
      
      // Volver a la pantalla de inicio
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      
      // Verificar que estamos de vuelta en la pantalla de inicio
      expect(find.text('Conference App'), findsOneWidget);
    });
    
    testWidgets('Subscribe to event and verify it appears in My Events', 
        (WidgetTester tester) async {
      // Iniciar la aplicación
      app.main();
      await tester.pumpAndSettle();
      
      // Navegar a Event Tracks
      await tester.tap(find.text('View All'));
      await tester.pumpAndSettle();
      
      // Tocar el primer track
      await tester.tap(find.text('View Events').first);
      await tester.pumpAndSettle();
      
      // Seleccionar y abrir el primer evento
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();
      
      // Suscribirse al evento
      final subscribeButton = find.text('Subscribe to Event');
      if (subscribeButton.evaluate().isNotEmpty) {
        await tester.tap(subscribeButton);
        await tester.pumpAndSettle();
      }
      
      // Volver a la pantalla de inicio
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      
      // Navegar a Mis Eventos
      await tester.tap(find.text('My Events'));
      await tester.pumpAndSettle();
      
      // Verificar que hay al menos un evento suscrito
      expect(find.byType(Card), findsWidgets);
    });
    
    testWidgets('Test offline mode functionality', 
        (WidgetTester tester) async {
      // Iniciar la aplicación
      app.main();
      await tester.pumpAndSettle();
      
      // Navegar a Event Tracks
      await tester.tap(find.text('View All'));
      await tester.pumpAndSettle();
      
      // Ver tracks disponibles en modo online
      final onlineTracks = tester.widgetList(find.byType(Card)).length;
      
      // Simular desconexión
      Get.find<ConnectionService>().isOnline.value = false;
      
      // Volver a la pantalla de inicio
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();
      
      // Navegar a Event Tracks nuevamente
      await tester.tap(find.text('View All'));
      await tester.pumpAndSettle();
      
      // Verificar que los tracks se cargan desde caché
      expect(tester.widgetList(find.byType(Card)).length, onlineTracks);
      
      // Restaurar conexión
      Get.find<ConnectionService>().isOnline.value = true;
    });
  });
}