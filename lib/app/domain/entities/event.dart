import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 2)
class Event {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String location;
  
  @HiveField(3)
  final DateTime dateTime;
  
  @HiveField(4)
  final int maxParticipants;
  
  @HiveField(5)
  final int currentParticipants;
  
  @HiveField(6)
  final String description;
  
  @HiveField(7)
  final String trackId;
  
  @HiveField(8)
  final double? averageRating;

  Event({
    required this.id,
    required this.name,
    required this.location,
    required this.dateTime,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.description,
    required this.trackId,
    this.averageRating,
  });

  // Check if event is in the past
  bool get isPast => dateTime.isBefore(DateTime.now());

  // Check if event has available spots
  bool get hasAvailableSpots => currentParticipants < maxParticipants;

  // Get number of available spots
  int get availableSpots => maxParticipants - currentParticipants;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'dateTime': dateTime.toIso8601String(),
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'description': description,
      'trackId': trackId,
      'averageRating': averageRating,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      dateTime: DateTime.parse(json['dateTime']),
      maxParticipants: json['maxParticipants'],
      currentParticipants: json['currentParticipants'],
      description: json['description'],
      trackId: json['trackId'],
      averageRating: json['averageRating'],
    );
  }
}