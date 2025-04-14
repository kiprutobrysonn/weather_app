import 'package:weather_app/src/features/home_page/domain/models/location.dart';

class LocationDto extends SavedLocation {
  LocationDto({
    required double latitude,
    required double longitude,
    required String name,
    String? country,
    bool isSaved = false,
  }) : super(
         latitude: latitude,
         longitude: longitude,
         name: name,
         country: country,
         isSaved: isSaved,
       );

  factory LocationDto.fromJson(Map json) {
    return LocationDto(
      latitude: json['latitude'],
      longitude: json['longitude'],
      name: json['name'],
      country: json['country'],
    );
  }

  Map toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'country': country,
      'isSaved': isSaved,
    };
  }
}
