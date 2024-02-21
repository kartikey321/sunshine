class Address {
  String placeName;
  double latitude;
  double longitude;
  String placeId;
  String placeFormattedAddress;

  Address(
      {required this.longitude,
      required this.latitude,
      required this.placeFormattedAddress,
      required this.placeId,
      required this.placeName});

  factory Address.fromMap(Map map) {
    return Address(
        placeName: map['result']['name'],
        placeId: map['result']['place_id'],
        latitude: map['result']['geometry']['location']['lat'],
        longitude: map['result']['geometry']['location']['lng'],
        placeFormattedAddress: map['result']['formatted_address']);
  }
}
