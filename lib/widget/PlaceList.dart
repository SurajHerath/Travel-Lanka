import 'package:flutter/material.dart';
import 'package:travel_lanka/view/PlaceDetailsPage.dart';

class PlaceList extends StatefulWidget {
  final String place;
  final String description;
  final String image;
  final String category;
  final double rating;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAdd;
  final bool isAdded;

  const PlaceList({
    Key? key,
    required this.place,
    required this.description,
    required this.image,
    required this.category,
    required this.rating,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onAdd,
    required this.isAdded,
  }) : super(key: key);

  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  late bool isAdded;

  @override
  void initState() {
    super.initState();
    isAdded = widget.isAdded;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailsPage(
              place: widget.place,
              description: widget.description,
              image: widget.image,
              category: widget.category,
              rating: widget.rating,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: widget.image.isNotEmpty
                  ? Image.network(
                widget.image,
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
                color: Colors.grey[300],
                child: const Icon(
                  Icons.image,
                  size: 500,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.place,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),
                    ],
                  ),
                  Text(
                    widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.redAccent[700],
                    size: 35,
                  ),
                  onPressed: widget.onFavoriteToggle,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isAdded ? Icons.cancel : Icons.add_circle_outline_rounded,
                        color: isAdded ? Colors.redAccent[700] : Colors.green,
                        size: 35,
                      ),
                      onPressed: () {
                        setState(() {
                          isAdded = !isAdded;
                        });
                        widget.onAdd();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

