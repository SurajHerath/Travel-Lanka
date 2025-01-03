import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String tripName;
  final String destination;
  final String startDate;
  final String endDate;
  final String category;

  const TripCard({
    Key? key,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Trip Details in a Horizontal Layout
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trip Name
                  Text(
                    tripName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Destination
                  Text(
                    'Destination: $destination',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Start and End Dates
                  Row(
                    children: [
                      Text(
                        'Start: $startDate',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'End: $endDate',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Category
                  Text(
                    'Category: $category',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
