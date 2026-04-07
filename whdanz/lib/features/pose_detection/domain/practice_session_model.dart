class PracticeSession {
  final String id;
  final String userId;
  final String danceStyle;
  final String? videoUrl;
  final int score;
  final List<String> feedback;
  final DateTime createdAt;
  final Duration duration;

  const PracticeSession({
    required this.id,
    required this.userId,
    required this.danceStyle,
    this.videoUrl,
    required this.score,
    this.feedback = const [],
    required this.createdAt,
    required this.duration,
  });

  factory PracticeSession.fromJson(Map<String, dynamic> json) {
    return PracticeSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      danceStyle: json['danceStyle'] as String,
      videoUrl: json['videoUrl'] as String?,
      score: json['score'] as int,
      feedback: (json['feedback'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      duration: Duration(seconds: json['durationSeconds'] as int? ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'danceStyle': danceStyle,
      'videoUrl': videoUrl,
      'score': score,
      'feedback': feedback,
      'createdAt': createdAt.toIso8601String(),
      'durationSeconds': duration.inSeconds,
    };
  }
}