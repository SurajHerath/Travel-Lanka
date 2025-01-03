class Place {
  String? id;
  String place;
  String description;
  String category;
  String image;
  String location;
  String district;
  String user;

  Place({
    this.id,
    required this.place,
    required this.description,
    required this.category,
    required this.image,
    required this.location,
    required this.district,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'place': place,
      'descript': description,
      'image': image,
      'category': category,
      'location': location,
      'district': district,
      'user': user,
    };
  }

  static Place fromMap(String id, Map<String, dynamic> map) {
    return Place(
      id: id,
      place: map['place'] ?? '',
      description: map['descript'] ?? '',
      category: map['category'] ?? '',
      image: map['image'] ?? '',
      location: map['location'] ?? '',
      district: map['district'] ?? '',
      user: map['user'] ?? '',
    );
  }
}
