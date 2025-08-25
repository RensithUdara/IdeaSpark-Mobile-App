class StartupIdea {
  String id;
  String name;
  String tagline;
  String description;
  int aiRating;
  int votes;
  DateTime createdAt;

  StartupIdea({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.aiRating,
    this.votes = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'aiRating': aiRating,
      'votes': votes,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory StartupIdea.fromJson(Map<String, dynamic> json) {
    return StartupIdea(
      id: json['id'],
      name: json['name'],
      tagline: json['tagline'],
      description: json['description'],
      aiRating: json['aiRating'],
      votes: json['votes'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }
}
