# Conference App

Una aplicación Flutter para la gestión de conferencias que permite a los usuarios explorar tracks de eventos, ver detalles, suscribirse y proporcionar retroalimentación.

## Características

- Exploración de tracks de eventos
- Vista detallada de eventos
- Suscripción/cancelación de suscripción a eventos
- Modo sin conexión (offline)
- Sincronización con backend
- Sistema de retroalimentación para eventos pasados

## Requisitos previos

- Flutter (versión recomendada: 3.x.x)
- Dart (versión recomendada: 3.x.x)
- Android Studio o VS Code con las extensiones de Flutter
- Emulador o dispositivo físico Android/iOS

## Instalación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/yourusername/conference_app.git
   cd conference_app
   ```

2. Instala las dependencias:
   ```bash
   flutter pub get
   ```

3. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## Estructura del proyecto

La aplicación sigue la arquitectura GetX y está organizada en:

- `/lib/app/core`: Contiene elementos base como temas y widgets
- `/lib/app/data`: Implementaciones de repositorios, fuentes de datos y servicios
- `/lib/app/domain`: Entidades y definiciones abstractas de repositorios
- `/lib/app/modules`: Módulos de la aplicación con sus respectivos controladores y vistas
- `/lib/app/routes`: Definición de rutas de la aplicación

## Pruebas

### Pruebas de Widgets

Las pruebas de widgets verifican que los componentes individuales de la UI funcionen correctamente.

Para ejecutar las pruebas de widgets:

```bash
flutter test test/widget_test.dart
```

Las pruebas de widgets incluyen:

- Verificación de inicialización correcta de la aplicación
- Carga apropiada de componentes de UI

### Pruebas de Integración

Las pruebas de integración verifican que los distintos componentes de la aplicación funcionen correctamente en conjunto.

Para ejecutar las pruebas de integración:

```bash
flutter test integration_test/app_test.dart
```

Las pruebas de integración incluyen:

1. **Full app journey test**: Verifica el flujo de navegación completo de la aplicación:
   - Carga de la pantalla de inicio
   - Navegación a Event Tracks
   - Exploración de eventos de un track
   - Navegación entre pantallas principales

2. **Subscribe to event and verify it appears in My Events**: Prueba el proceso de suscripción a eventos:
   - Navegación a Event Tracks
   - Selección de un track y un evento
   - Suscripción al evento
   - Verificación de que el evento aparece en la sección "My Events"

3. **Test offline mode functionality**: Verifica la funcionalidad offline de la aplicación:
   - Carga de datos en modo online
   - Simulación de modo offline
   - Verificación de que los datos se cargan correctamente desde la caché local

## Licencia

[MIT](LICENSE)
