class Track {
  final String id;
  final String name;
  final String description;

  Track({
    required this.id,
    required this.name,
    required this.description,
  });

  // Convert to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  // Create from Map
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
