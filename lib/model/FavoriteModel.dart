class FavoriteModel {
  final String placeId;

  FavoriteModel({required this.placeId});

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      placeId: map['placeId'] as String,
    );
  }
}

