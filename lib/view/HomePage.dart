import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:travel_lanka/controller/FavoriteController.dart';
import 'package:travel_lanka/widget/PlaceList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _searchQuery;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search by district...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text("Category", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryButton(null, Icons.all_inclusive, "All"),
                  _buildCategoryButton("Hotel", Icons.bed),
                  _buildCategoryButton("LandMark", Icons.location_on),
                  _buildCategoryButton("Restaurant", Icons.restaurant),
                  _buildCategoryButton("Park", Icons.park),
                  _buildCategoryButton("ATM", Icons.attach_money),
                  _buildCategoryButton("Gas Station", Icons.local_gas_station),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text("Most Recommended", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _getFilteredPlaces(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data.'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final places = snapshot.data!.docs;
                if (places.isEmpty) {
                  return const Center(child: Text('No places found.'));
                }

                return Consumer<FavoriteController>(
                  builder: (context, favoriteController, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        final doc = places[index];
                        final placeId = doc.id;
                        final data = doc.data() as Map<String, dynamic>;
                        bool isAdded = false;

                        return PlaceList(
                          place: data['place'] ?? '',
                          description: data['descript'] ?? '',
                          image: data['image'] ?? '',
                          category: data['category'] ?? '',
                          rating: 4.5,
                          isFavorite: favoriteController.isFavorite(placeId),
                          onFavoriteToggle: () {
                            favoriteController.toggleFavorite(placeId);
                          },
                          onAdd: () {
                            setState(() {
                              isAdded = !isAdded;
                            });
                          },
                          isAdded: isAdded,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String? category, IconData icon, [String? label]) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        icon: Icon(icon),
        label: Text(label ?? category ?? ""),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: _selectedCategory == category ? Colors.redAccent[700] : Colors.grey[300],
          foregroundColor: _selectedCategory == category ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getFilteredPlaces() {
    Query query = _firestore.collection('places');
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      query = query.where('district', isEqualTo: _searchQuery);
    }
    if (_selectedCategory != null) {
      query = query.where('category', isEqualTo: _selectedCategory);
    }
    return query.snapshots();
  }
}

