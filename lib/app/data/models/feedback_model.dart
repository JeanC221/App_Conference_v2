class EventFeedback {
  final String eventId;
  final String feedback;
  final double rating;
  final DateTime submittedAt;

  EventFeedback({
    required this.eventId,
    required this.feedback,
    required this.rating,
    required this.submittedAt,
  });

  // Convert to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'feedback': feedback,
      'rating': rating,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  // Create from Map
  factory EventFeedback.fromJson(Map<String, dynamic> json) {
    return EventFeedback(
      eventId: json['eventId'],
      feedback: json['feedback'],
      rating: json['rating'],
      submittedAt: DateTime.parse(json['submittedAt']),
    );
  }
}
