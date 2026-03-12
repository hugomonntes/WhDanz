import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whdanz/features/pose_detection/domain/practice_session_model.dart';

class PracticeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveSession(PracticeSession session) async {
    await _firestore.collection('practice_sessions').doc(session.id).set(session.toJson());
  }

  Future<List<PracticeSession>> getUserSessions(String userId) async {
    final snapshot = await _firestore.collection('practice_sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => PracticeSession.fromJson(doc.data())).toList();
  }

  Future<double> getAverageScore(String userId) async {
    final snapshot = await _firestore.collection('practice_sessions')
        .where('userId', isEqualTo: userId)
        .get();
    
    if (snapshot.docs.isEmpty) return 0;
    
    double total = 0;
    for (final doc in snapshot.docs) {
      total += doc.data()['score'] as double;
    }
    return total / snapshot.docs.length;
  }

  Stream<List<PracticeSession>> getUserSessionsStream(String userId) {
    return _firestore.collection('practice_sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => PracticeSession.fromJson(doc.data())).toList());
  }
}
