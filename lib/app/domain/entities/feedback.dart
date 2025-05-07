import 'package:hive/hive.dart';

part 'feedback.g.dart';

@HiveType(typeId: 3)
class EventFeedback {
  @HiveField(0)
  final String eventId;
  
  @HiveField(1)
  final String feedback;
  
  @HiveField(2)
  final double rating;
  
  @HiveField(3)
  final DateTime submittedAt;

  EventFeedback({
    required this.eventId,
    required this.feedback,
    required this.rating,
    required this.submittedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'feedback': feedback,
      'rating': rating,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory EventFeedback.fromJson(Map<String, dynamic> json) {
    return EventFeedback(
      eventId: json['eventId'],
      feedback: json['feedback'],
      rating: json['rating'],
      submittedAt: DateTime.parse(json['submittedAt']),
    );
  }
}