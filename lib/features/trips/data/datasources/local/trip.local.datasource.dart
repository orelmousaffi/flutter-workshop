import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:hive/hive.dart';

class TripLocalDataSource {
  final Box<Trip> tripBox;

  TripLocalDataSource({required this.tripBox});

  List<Trip> getTrips() {
    return tripBox.values.toList();
  }

  void addTrip(Trip trip) {
    tripBox.add(trip);
  }
}
