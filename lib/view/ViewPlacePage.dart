import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_lanka/widget/PlaceCard.dart';
import 'package:travel_lanka/view/AddPlacePage.dart';
import 'package:travel_lanka/model/PlaceModel.dart';
class ViewPlacePage extends StatefulWidget {
  final String email;

  const ViewPlacePage({Key? key, required this.email}) : super(key: key);

  @override
  _ViewPlacePageState createState() => _ViewPlacePageState();
}

class _ViewPlacePageState extends State<ViewPlacePage> {
  final CollectionReference places = FirebaseFirestore.instance.collection('places');

  Future<void> deletePlace(String docId) async {
    try {
      await places.doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Place deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete place: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        child: Column(
          children: [
            // Fixed Elevated Button at the Top
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Filtering Firestore query by the user's email
                      StreamBuilder(
                        stream: places.where('user', isEqualTo: widget.email).snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Error loading data.'),
                            );
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final data = snapshot.data!.docs;
                          if (data.isEmpty) {
                            return const Center(child: Text('No places found.'));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final doc = data[index];
                              final place = doc['place'] ?? '';
                              final description = doc['descript'] ?? '';
                              final image = doc['image'] ?? '';
                              final category = doc['category'] ?? '';
                              final location = doc['location'] ?? '';
                              final district = doc['district'] ?? '';

                              return PlaceCard(
                                place: place,
                                description: description,
                                image: image,
                                category: category,
                                rating: 4.5,
                                isFavorite: false,
                                onFavoriteToggle: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Favorite toggled!')),
                                  );
                                },
                                onEdit: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AddPlacePage(
                                        docId: doc.id,
                                        initialData: Place(
                                          id: doc.id,
                                          place: place,
                                          description: description,
                                          image: image,
                                          category: category,
                                          location: location,
                                          district: district,
                                          user: widget.email,
                                        ),
                                        email: widget.email,
                                      ),
                                    ),
                                  );
                                },
                                onDelete: () => deletePlace(doc.id),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPlacePage(email: widget.email),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Add a Place',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
