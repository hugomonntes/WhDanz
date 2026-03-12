import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whdanz/features/places/domain/place_model.dart';

class PlaceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PlaceModel>> getAllPlaces() async {
    final snapshot = await _firestore.collection('places').get();
    return snapshot.docs.map((doc) => PlaceModel.fromJson(doc.data())).toList();
  }

  Future<List<PlaceModel>> getPlacesByType(String type) async {
    final snapshot = await _firestore.collection('places')
        .where('type', isEqualTo: type)
        .get();
    return snapshot.docs.map((doc) => PlaceModel.fromJson(doc.data())).toList();
  }

  Future<PlaceModel?> getPlaceById(String placeId) async {
    final doc = await _firestore.collection('places').doc(placeId).get();
    if (doc.exists) {
      return PlaceModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> createPlace(PlaceModel place) async {
    await _firestore.collection('places').doc(place.id).set(place.toJson());
  }

  Future<void> updatePlace(String placeId, Map<String, dynamic> data) async {
    await _firestore.collection('places').doc(placeId).update(data);
  }

  Future<void> deletePlace(String placeId) async {
    await _firestore.collection('places').doc(placeId).delete();
  }

  Future<void> addReview(String placeId, Map<String, dynamic> review) async {
    await _firestore.collection('places').doc(placeId).collection('reviews').add(review);
  }

  Stream<List<Map<String, dynamic>>> getReviews(String placeId) {
    return _firestore.collection('places').doc(placeId).collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<List<PlaceModel>> searchPlaces(String query) async {
    final snapshot = await _firestore.collection('places')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    return snapshot.docs.map((doc) => PlaceModel.fromJson(doc.data())).toList();
  }
}
