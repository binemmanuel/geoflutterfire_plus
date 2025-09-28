import 'dart:io';

import 'package:dart_firebase_admin/firestore.dart' hide DocumentData;
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:example/user.location.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

void main(List<String> arguments) async {
  final app = FirebaseAdminApp.initializeApp(
    '<app-id>',
    Credential.fromServiceAccount(File('lib/service-account.json')),
  );

  final firestore = Firestore(app);

  final center = GeoFirePoint(
    GeoPoint(latitude: 9.0957856, longitude: 7.4085107),
  );

  final collection = firestore
      .collection('users')
      .withConverter(
        fromFirestore: (data) => UserLocation.fromMap(data.data()),
        toFirestore: (data) => data.toMap(),
      );

  final collectionRef = GeoCollectionReference(collection);

  final userLocation = UserLocation(
    geopoint: GeoFirePoint(GeoPoint(latitude: 9.0957856, longitude: 7.4085107)),
  );

  await collectionRef.set(id: 'user-1', data: userLocation);

  print('Data added successfully');

  collectionRef
      .fetchWithinWithDistance(
        center: center,
        radiusInKm: 5,
        field: 'geo',
        geopointFrom: (data) => data.geopoint.geopoint,
      )
      .then(
        (snapshots) {
          final data = snapshots.map((snapshot) {
            return {
              'distanceFromCenterInKm': snapshot.distanceFromCenterInKm,
              'data': snapshot.documentSnapshot.data()?.toMap(),
            };
          }).toList();

          print(data);
        },
        onError: (error, stackTrace) {
          print(error);
          print(stackTrace);
        },
      );
}
