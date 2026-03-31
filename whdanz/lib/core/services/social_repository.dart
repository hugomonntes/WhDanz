import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whdanz/features/social_feed/domain/story_model.dart';
import 'package:whdanz/features/social_feed/domain/reel_model.dart';
import 'package:whdanz/features/social_feed/domain/message_model.dart';
import 'package:whdanz/features/social_feed/domain/comment_model.dart';
import 'package:whdanz/features/social_feed/domain/follow_model.dart';

class SocialRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Posts
  Future<List<Map<String, dynamic>>> getFeedPosts({int limit = 20}) async {
    final snapshot = await _firestore.collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> createPost(Map<String, dynamic> post) async {
    await _firestore.collection('posts').doc(post['id']).set(post);
  }

  // Stories
  Future<List<StoryModel>> getStories() async {
    final snapshot = await _firestore.collection('stories')
        .where('createdAt', isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)))
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => StoryModel.fromJson(doc.data())).toList();
  }

  Future<void> createStory(StoryModel story) async {
    await _firestore.collection('stories').doc(story.id).set(story.toJson());
  }

  Future<void> viewStory(String storyId, String userId) async {
    await _firestore.collection('stories').doc(storyId).collection('views').doc(userId).set({
      'userId': userId,
      'viewedAt': DateTime.now(),
    });
  }

  // Reels
  Future<List<ReelModel>> getReels() async {
    final snapshot = await _firestore.collection('reels')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();
    return snapshot.docs.map((doc) => ReelModel.fromJson(doc.data())).toList();
  }

  Future<void> createReel(ReelModel reel) async {
    await _firestore.collection('reels').doc(reel.id).set(reel.toJson());
  }

  // Messages
  Future<List<ConversationModel>> getConversations(String userId) async {
    final snapshot = await _firestore.collection('conversations')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .get();
    return snapshot.docs.map((doc) => ConversationModel.fromJson(doc.data())).toList();
  }

  Future<List<MessageModel>> getMessages(String conversationId, {int limit = 50}) async {
    final snapshot = await _firestore.collection('conversations').doc(conversationId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => MessageModel.fromJson(doc.data())).toList();
  }

  Future<void> sendMessage(MessageModel message) async {
    final conversationRef = _firestore.collection('conversations').doc(message.receiverId);
    await conversationRef.collection('messages').doc(message.id).set(message.toJson());
    await conversationRef.update({
      'lastMessage': message.content,
      'lastMessageTime': Timestamp.fromDate(message.createdAt),
    });
  }

  // Comments
  Future<List<CommentModel>> getComments(String postId, {int limit = 50}) async {
    final snapshot = await _firestore.collection('posts').doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => CommentModel.fromJson(doc.data())).toList();
  }

  Future<void> addComment(CommentModel comment) async {
    await _firestore.collection('posts').doc(comment.postId)
        .collection('comments').doc(comment.id).set(comment.toJson());
  }

  // Follows
  Future<void> follow(String followerId, String followingId) async {
    final now = DateTime.now();
    await _firestore.collection('follows').doc('${followerId}_$followingId').set({
      'followerId': followerId,
      'followingId': followingId,
      'createdAt': Timestamp.fromDate(now),
    });
  }

  Future<void> unfollow(String followerId, String followingId) async {
    await _firestore.collection('follows').doc('${followerId}_$followingId').delete();
  }

  Future<bool> isFollowing(String followerId, String followingId) async {
    final doc = await _firestore.collection('follows').doc('${followerId}_$followingId').get();
    return doc.exists;
  }

  Future<List<String>> getFollowers(String userId) async {
    final snapshot = await _firestore.collection('follows')
        .where('followingId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => doc.data()['followerId'] as String).toList();
  }

  Future<List<String>> getFollowing(String userId) async {
    final snapshot = await _firestore.collection('follows')
        .where('followerId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => doc.data()['followingId'] as String).toList();
  }

  Future<int> getFollowersCount(String userId) async {
    final snapshot = await _firestore.collection('follows')
        .where('followingId', isEqualTo: userId)
        .get();
    return snapshot.size;
  }

  Future<int> getFollowingCount(String userId) async {
    final snapshot = await _firestore.collection('follows')
        .where('followerId', isEqualTo: userId)
        .get();
    return snapshot.size;
  }
}
