import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whdanz/features/social_feed/domain/post_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PostModel>> getFeedPosts({int limit = 20, DocumentSnapshot? lastDoc}) async {
    Query query = _firestore.collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<PostModel>> getUserPosts(String userId) async {
    final snapshot = await _firestore.collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> createPost(PostModel post) async {
    await _firestore.collection('posts').doc(post.id).set(post.toJson());
  }

  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  Future<void> likePost(String postId, String userId) async {
    await _firestore.collection('posts').doc(postId).collection('likes').doc(userId).set({
      'userId': userId,
      'likedAt': DateTime.now(),
    });
  }

  Future<void> unlikePost(String postId, String userId) async {
    await _firestore.collection('posts').doc(postId).collection('likes').doc(userId).delete();
  }

  Stream<bool> isPostLiked(String postId, String userId) {
    return _firestore.collection('posts').doc(postId).collection('likes').doc(userId).snapshots().map(
      (doc) => doc.exists,
    );
  }

  Stream<int> getLikesCount(String postId) {
    return _firestore.collection('posts').doc(postId).collection('likes').snapshots().map(
      (snapshot) => snapshot.size,
    );
  }
}
