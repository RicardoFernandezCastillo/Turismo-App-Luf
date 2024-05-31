/*

{
  "id": "RECORD_ID",
  "collectionId": "somsequ5ehmdtsh",
  "collectionName": "location",
  "created": "2022-01-01 01:00:00.123Z",
  "updated": "2022-01-01 23:59:59.456Z",
  "name": "test",
  "address": "test",
  "longitude": 123,
  "latitude": 123,
  "description": "test",
  "status": "active",
  "photos": [
    "filename.jpg"
  ],
  "city_id": "RELATION_RECORD_ID",
  "category_id": [
    "RELATION_RECORD_ID"
  ],
  "user_id": "RELATION_RECORD_ID",
  "type": "test",
  "schedule": "test"
}

*/


class Place {
  String? id;
  String? collectionId;
  String? collectionName;
  String name;
  String address;
  double longitude;
  double latitude;
  String description;
  String status;
  List<String> photos;
  String? cityId;
  List<String>? categoryId;
  String ?type;
  String? schedule;

  Place({
    required this.id,
    required this.collectionId,
    required this.collectionName,
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.description,
    required this.status,
    required this.photos,
    required this.cityId,
    required this.categoryId,
    required this.type,
    required this.schedule,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      name: json['name'],
      address: json['address'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      description: json['description'],
      status: json['status'],
      photos: List<String>.from(json['photos']),
      cityId: json['cityId'],
      categoryId: List<String>.from(json['categoryId']),
      type: json['type'],
      schedule: json['schedule'],
    );
  }
}