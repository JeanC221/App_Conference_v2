import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/event_tracks/bindings/event_tracks_binding.dart';
import '../modules/event_tracks/views/event_tracks_view.dart' as tracks;
import '../modules/subscribed_events/bindings/subscribed_events_binding.dart';
import '../modules/subscribed_events/views/subscribed_events_view.dart';
import '../modules/event_details/bindings/event_details_binding.dart';
import '../modules/event_details/views/event_details_view.dart' as details;

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_TRACKS,
      page: () => const tracks.EventTracksView(),
      binding: EventTracksBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIBED_EVENTS,
      page: () => const SubscribedEventsView(),
      binding: SubscribedEventsBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_DETAILS,
      page: () => const details.EventDetailsView(),
      binding: EventDetailsBinding(),
    ),
  ];
}
