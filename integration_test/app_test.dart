import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:conference_app/main.dart' as app;

void main() {
  // Inicializa el binding para pruebas de integración
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Test', () {
    testWidgets('Full app journey test', (WidgetTester tester) async {
      // Iniciar la aplicación
      app.main();
      await tester.pumpAndSettle();

      // Verificar que estamos en la pantalla de inicio
      expect(find.text('Conference App'), findsOneWidget);
      
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
  });
}