import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final String place;
  final String description;
  final String image;
  final String category;
  final double rating;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PlaceCard({
    Key? key,
    required this.place,
    required this.description,
    required this.image,
    required this.category,
    required this.rating,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Image: $image');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: image.isNotEmpty
                ? Image.network(
                image,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                 errorBuilder: (context, error, stackTrace) {
                 return Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ),
                );
              },
            )
                : Container(
                  height: 150,
                  width: 200,
                  color: Colors.grey[300],
                  child: const Icon(
                Icons.image,
                size: 500,
                color: Colors.grey,
              ),
            ),
          ),


          // Details Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  place,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Small Content
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 8),

                // Star Rating
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating.round()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
          ),

          // Bottom Section with Heart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent[700],
                ),
                onPressed: onFavoriteToggle,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
