import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderPhotoURL;
  final String receiverId;
  final String content;
  final String? mediaURL;
  final String mediaType;
  final DateTime createdAt;
  final bool isRead;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderPhotoURL,
    required this.receiverId,
    required this.content,
    this.mediaURL,
    this.mediaType = 'text',
    required this.createdAt,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderPhotoURL: json['senderPhotoURL'] as String?,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      mediaURL: json['mediaURL'] as String?,
      mediaType: json['mediaType'] as String? ?? 'text',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoURL': senderPhotoURL,
      'receiverId': receiverId,
      'content': content,
      'mediaURL': mediaURL,
      'mediaType': mediaType,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
    };
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderPhotoURL,
    String? receiverId,
    String? content,
    String? mediaURL,
    String? mediaType,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderPhotoURL: senderPhotoURL ?? this.senderPhotoURL,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      mediaURL: mediaURL ?? this.mediaURL,
      mediaType: mediaType ?? this.mediaType,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

class ConversationModel {
  final String id;
  final String participantId;
  final String participantName;
  final String? participantPhotoURL;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ConversationModel({
    required this.id,
    required this.participantId,
    required this.participantName,
    this.participantPhotoURL,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      participantId: json['participantId'] as String,
      participantName: json['participantName'] as String,
      participantPhotoURL: json['participantPhotoURL'] as String?,
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: (json['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantId': participantId,
      'participantName': participantName,
      'participantPhotoURL': participantPhotoURL,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unreadCount': unreadCount,
    };
  }
}
