class Event {
  final String id;
  final String name;
  final String location;
  final DateTime dateTime;
  final int maxParticipants;
  final int currentParticipants;
  final String description;
  final String trackId;
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

  // Convert to Map for storage
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

  // Create from Map
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
