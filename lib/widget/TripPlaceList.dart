import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripPlaceList extends StatefulWidget {
  final String email;
  final String placeId;
  final String place;
  final String description;
  final String image;
  final String category;

  const TripPlaceList({
    Key? key,
    required this.email,
    required this.placeId,
    required this.place,
    required this.description,
    required this.image,
    required this.category,
  }) : super(key: key);

  @override
  _TripPlaceListState createState() => _TripPlaceListState();
}

class _TripPlaceListState extends State<TripPlaceList> {
  double _rating = 0;
  String _review = '';

  void _showReviewDialog(String placeId, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Write a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    _review = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Write your review here...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  try {
                    await FirebaseFirestore.instance
                        .collection('places')
                        .doc(placeId)
                        .collection('feedback')
                        .add({
                      'feedback': _review,
                      'user': userId,
                      'rating': _rating,
                    });
                    print('Feedback submitted for place $placeId');
                  } catch (e) {
                    print('Failed to submit feedback: $e');
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
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
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.place,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.description,
                ),
                // Rating Stars
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1.0;
                        });
                        print('Number of stars selected: $_rating');
                        _showReviewDialog(widget.placeId, widget.email);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
