class SavedLocation {
  final double latitude;
  final double longitude;
  final String name;
  final String? country;
  final bool isSaved;
  final bool isHome;

  SavedLocation({
    required this.latitude,
    required this.longitude,
    required this.name,
    this.country,
    this.isSaved = false,
    this.isHome = false,
  });
}
