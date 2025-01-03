import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_lanka/widget/TripPlaceList.dart';
import 'package:travel_lanka/controller/TripController.dart';

import '../controller/TripController.dart';

class ViewTripPage extends StatefulWidget {
  final String email;
  final String tripId;
  final String tripName;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String category;
  final List<String> places;

  const ViewTripPage({
    Key? key,
    required this.email,
    required this.tripId,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.places,
  }) : super(key: key);

  @override
  _ViewTripPageState createState() => _ViewTripPageState();
}

class _ViewTripPageState extends State<ViewTripPage> {
  late List<String> placeList;
  final TripController _tripController = TripController();

  @override
  void initState() {
    super.initState();
    placeList = List.from(widget.places);
  }

  void removePlace(int index) {
    setState(() {
      placeList.removeAt(index);
    });
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Trip"),
          content: const Text("Are you sure you want to delete this trip?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteTrip();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTrip() async {
    try {
      await _tripController.deleteTrip(widget.tripId);
      Navigator.of(context).pop(); // Go back to the previous page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting trip: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(widget.startDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(widget.endDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tripName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,)),
        backgroundColor: Colors.redAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip Name: ${widget.tripName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Destination: ${widget.destination}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Start Date: $formattedStartDate',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'End Date: $formattedEndDate',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Places to Visit:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: placeList.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('places')
                        .doc(placeList[index])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Text(
                          '- Unknown place (ID: ${placeList[index]})',
                          style: const TextStyle(fontSize: 16),
                        );
                      }
                      var placeData = snapshot.data!.data() as Map<String, dynamic>;

                      return TripPlaceList(
                        email: widget.email,
                        placeId: placeList[index],
                        place: placeData['place'] ?? 'Unnamed Place',
                        description: placeData['descript'] ?? 'No description available',
                        image: placeData['image'] ?? '',
                        category: placeData['category'] ?? 'No category',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

