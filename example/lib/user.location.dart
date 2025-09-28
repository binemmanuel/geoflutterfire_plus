import 'dart:convert';

import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class UserLocation {
  final GeoFirePoint geopoint;

  const UserLocation({required this.geopoint});

  Map<String, dynamic> toMap() {
    return {'geo': geopoint.toMap()};
  }

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(geopoint: GeoFirePoint.fromMap(map['geo']));
  }

  String toJson() => json.encode(toMap());

  factory UserLocation.fromJson(String source) =>
      UserLocation.fromMap(json.decode(source));
}
