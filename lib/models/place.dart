class Place {
  final String placeId;
  final String placeDescription;

  Place({
    required this.placeId,
    required this.placeDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'placeDescription': placeDescription,
    };
  }

  @override
  String toString() {
    return 'Place{placeId: $placeId, placeDescription: $placeDescription}';
  }
}
