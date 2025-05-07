import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:conference_app/app/routes/app_pages.dart';

void main() {
  testWidgets('Basic app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );

    // Verifica que la app se inicia correctamente
    expect(find.byType(GetMaterialApp), findsOneWidget);
  });
}