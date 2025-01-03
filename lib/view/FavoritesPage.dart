import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:travel_lanka/controller/FavoriteController.dart';
import 'package:travel_lanka/widget/PlaceList.dart';

class FavoritesPage extends StatelessWidget {
  final String email;

  const FavoritesPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteController = Provider.of<FavoriteController>(context);
    final favorites = favoriteController.favorites;

    if (favorites.isEmpty) {
      return const Center(
        child: Text('No favorite places yet'),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('places')
            .where(FieldPath.documentId, whereIn: favorites.toList())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading favorites'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final places = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final doc = places[index];
              final data = doc.data() as Map<String, dynamic>;

              return PlaceList(
                place: data['place'] ?? '',
                description: data['descript'] ?? '',
                image: data['image'] ?? '',
                category: data['category'] ?? '',
                rating: 4.5,
                isFavorite: true,
                onFavoriteToggle: () => favoriteController.toggleFavorite(doc.id),
                onAdd: () {},
                isAdded: false,
              );
            },
          );
        },
      ),
    );
  }
}

