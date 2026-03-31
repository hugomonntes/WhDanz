import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoURL;
  final String mediaURL;
  final String mediaType;
  final Duration duration;
  final DateTime createdAt;
  final bool isViewed;

  const StoryModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoURL,
    required this.mediaURL,
    this.mediaType = 'image',
    this.duration = const Duration(seconds: 5),
    required this.createdAt,
    this.isViewed = false,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhotoURL: json['userPhotoURL'] as String?,
      mediaURL: json['mediaURL'] as String,
      mediaType: json['mediaType'] as String? ?? 'image',
      duration: Duration(seconds: json['durationSeconds'] as int? ?? 5),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isViewed: json['isViewed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhotoURL': userPhotoURL,
      'mediaURL': mediaURL,
      'mediaType': mediaType,
      'durationSeconds': duration.inSeconds,
      'createdAt': Timestamp.fromDate(createdAt),
      'isViewed': isViewed,
    };
  }

  StoryModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhotoURL,
    String? mediaURL,
    String? mediaType,
    Duration? duration,
    DateTime? createdAt,
    bool? isViewed,
  }) {
    return StoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoURL: userPhotoURL ?? this.userPhotoURL,
      mediaURL: mediaURL ?? this.mediaURL,
      mediaType: mediaType ?? this.mediaType,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      isViewed: isViewed ?? this.isViewed,
    );
  }
}
