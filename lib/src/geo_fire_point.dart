// import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';

import 'package:dart_firebase_admin/firestore.dart';

import 'math.dart';
import 'utils.dart' as utils;

/// A model corresponds to Cloud Firestore as geopoint field.
class GeoFirePoint {
  /// Instantiates [GeoFirePoint].
  const GeoFirePoint(this.geopoint);

  factory GeoFirePoint.fromMap(final Map<String, dynamic> map) {
    return GeoFirePoint(map['geopoint'] as GeoPoint);
  }

  factory GeoFirePoint.fromJson(final String source) =>
      GeoFirePoint.fromMap(json.decode(source) as Map<String, dynamic>);

  /// [GeoPoint] of the location.
  final GeoPoint geopoint;

  /// Returns latitude of the location.
  double get latitude => geopoint.latitude;

  /// Returns longitude of the location.
  double get longitude => geopoint.longitude;

  /// Returns geohash of [GeoFirePoint].
  String get geohash =>
      encode(latitude: geopoint.latitude, longitude: geopoint.longitude);

  /// Returns all neighbors of [GeoFirePoint].
  List<String> get neighbors => utils.neighborGeohashesOf(geohash: geohash);

  /// Returns distance in kilometers between [GeoFirePoint] and given
  /// [geopoint].
  double distanceBetweenInKm({required final GeoPoint geopoint}) =>
      distanceInKm(geopoint1: this.geopoint, geopoint2: geopoint);

  /// Returns [geopoint] and [geohash] as Map<String, dynamic>. Can be used when
  /// adding or updating to Firestore document.
  Map<String, dynamic> get data => {'geopoint': geopoint, 'geohash': geohash};

  Map<String, dynamic> toMap() => data;

  String toJson() => json.encode(toMap());
}
