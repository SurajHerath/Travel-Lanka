import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_lanka/model/TripModel.dart';

class TripController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTrip(Trip trip) async {
    try {
      await _firestore.collection('trip').add(trip.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await _firestore.collection('trip').doc(tripId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getFilteredPlaces(String district, String? category) {
    Query query = _firestore.collection('places');
    if (district.isNotEmpty) {
      query = query.where('district', isEqualTo: district);
    }
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots();
  }
}

