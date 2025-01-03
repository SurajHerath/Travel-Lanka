import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String name;
  final String userEmail;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> placeList;

  Trip({
    required this.name,
    required this.userEmail,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.placeList,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'user': userEmail,
      'destination': destination,
      'startdate': Timestamp.fromDate(startDate),
      'enddate': Timestamp.fromDate(endDate),
      'placeList': placeList,
    };
  }
}
