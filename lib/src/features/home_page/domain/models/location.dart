class SavedLocation {
  final double latitude;
  final double longitude;
  final String name;
  final String? country;
  final bool isSaved;

  SavedLocation({
    required this.latitude,
    required this.longitude,
    required this.name,
    this.country,
    this.isSaved = false,
  });
}
