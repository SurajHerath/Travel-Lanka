import 'package:flutter/material.dart';
import 'package:travel_lanka/model/PlaceModel.dart';
import 'package:travel_lanka/controller/PlaceController.dart';

class AddPlacePage extends StatefulWidget {
  final String? docId;
  final Place? initialData;
  final String email;

  AddPlacePage({this.docId, this.initialData, required this.email});

  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final PlaceController _placeController = PlaceController();

  final TextEditingController placeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String selectedCategory = 'Restaurant';
  String selectedDistrict = 'Colombo';

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final data = widget.initialData!;
      placeController.text = data.place;
      descriptionController.text = data.description;
      imageController.text = data.image;
      locationController.text = data.location;
      selectedCategory = data.category;
      selectedDistrict = data.district;
    }
  }

  Future<void> savePlace() async {
    Place place = Place(
      id: widget.docId,
      place: placeController.text.trim(),
      description: descriptionController.text.trim(),
      image: imageController.text.trim(),
      category: selectedCategory,
      location: locationController.text.trim(),
      district: selectedDistrict,
      user: widget.email,
    );

    try {
      if (widget.docId == null) {
        await _placeController.addPlace(place);
      } else {
        await _placeController.updatePlace(widget.docId!, place);
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.docId == null ? 'Place added!' : 'Place updated!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save place: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docId == null ? 'Add Place' : 'Update Place',style: TextStyle(color:Colors.white)),
        backgroundColor: Colors.redAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: placeController,
              decoration: const InputDecoration(
                labelText: 'Place',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: [
                'Restaurant',
                'LandMark',
                'Hotel',
                'Park',
                'ATM',
                'Gas Station',
              ].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'District',
                border: OutlineInputBorder(),
              ),
              items: [
                'Colombo',
                'Gampaha',
                'Kandy',
                'Galle',
                'Matara',
                'Jaffna',
              ].map((district) {
                return DropdownMenuItem(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: savePlace,
              child: Text(widget.docId == null ? 'Add Place' : 'Update Place',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
