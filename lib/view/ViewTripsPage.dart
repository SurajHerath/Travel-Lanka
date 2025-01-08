import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:travel_lanka/view/AddTripPage.dart';
import 'package:travel_lanka/widget/TripCard.dart';
import 'package:travel_lanka/view/ViewTripPage.dart';

class ViewTripsPage extends StatelessWidget {
  final String email;

  const ViewTripsPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tripsCollection = FirebaseFirestore.instance.collection('trip');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Retrieve all the trips with given user email and key word "all"
                stream: tripsCollection.where('user', whereIn: [email,'all']).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Trips Yet"));
                  }

                  var trips = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      var tripDoc = trips[index];
                      var tripData = tripDoc.data() as Map<String, dynamic>;

                      String tripName = tripData['name'] ?? 'Unknown place';
                      String destination = tripData['destination'] ?? 'No destination';
                      DateTime startDate = (tripData['startdate'] as Timestamp).toDate();
                      DateTime endDate = (tripData['enddate'] as Timestamp).toDate();
                      List<dynamic> rawPlaces = tripData['placeList'] ?? [];
                      List<String> places = rawPlaces.cast<String>();

                      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
                      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

                      return Dismissible(
                        key: ValueKey(tripDoc.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          await tripsCollection.doc(tripDoc.id).delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$tripName deleted.')),
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewTripPage(
                                  email: email,
                                  tripName: tripName,
                                  destination: destination,
                                  startDate: startDate,
                                  endDate: endDate,
                                  category: 'Trip',
                                  places: places,
                                ),
                              ),
                            );
                          },
                          child: TripCard(
                            tripName: tripName,
                            destination: destination,
                            startDate: formattedStartDate,
                            endDate: formattedEndDate,
                            category: 'Trip',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 5),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTripPage(email: email)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Create A Trip',
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
