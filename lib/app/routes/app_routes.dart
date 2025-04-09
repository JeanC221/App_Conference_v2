part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const EVENT_TRACKS = _Paths.EVENT_TRACKS;
  static const SUBSCRIBED_EVENTS = _Paths.SUBSCRIBED_EVENTS;
  static const EVENT_DETAILS = _Paths.EVENT_DETAILS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const EVENT_TRACKS = '/event-tracks';
  static const SUBSCRIBED_EVENTS = '/subscribed-events';
  static const EVENT_DETAILS = '/event-details';
}
