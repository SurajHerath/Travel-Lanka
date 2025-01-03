import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/FavoriteModel.dart';

class FavoriteController extends ChangeNotifier {
  final String email;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Set<String> _favorites = {};

  FavoriteController({required this.email}) {
    _loadFavorites();
  }

  Set<String> get favorites => _favorites;

  Future<void> _loadFavorites() async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(email)
          .collection('favorites')
          .doc('places')
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _favorites = Set<String>.from(data['placeIds'] ?? []);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> toggleFavorite(String placeId) async {
    try {
      if (_favorites.contains(placeId)) {
        _favorites.remove(placeId);
      } else {
        _favorites.add(placeId);
      }
      notifyListeners();

      await _firestore
          .collection('users')
          .doc(email)
          .collection('favorites')
          .doc('places')
          .set({
        'placeIds': _favorites.toList(),
      });
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  bool isFavorite(String placeId) {
    return _favorites.contains(placeId);
  }
}

