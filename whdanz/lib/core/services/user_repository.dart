import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/domain/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    await _firestore.collection('users').doc(currentUserId).collection('following').doc(targetUserId).set({
      'userId': targetUserId,
      'followedAt': DateTime.now(),
    });
    
    await _firestore.collection('users').doc(targetUserId).collection('followers').doc(currentUserId).set({
      'userId': currentUserId,
      'followedAt': DateTime.now(),
    });
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    await _firestore.collection('users').doc(currentUserId).collection('following').doc(targetUserId).delete();
    await _firestore.collection('users').doc(targetUserId).collection('followers').doc(currentUserId).delete();
  }

  Stream<List<String>> getFollowing(String userId) {
    return _firestore.collection('users').doc(userId).collection('following').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
    );
  }

  Stream<List<String>> getFollowers(String userId) {
    return _firestore.collection('users').doc(userId).collection('followers').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
    );
  }
}
