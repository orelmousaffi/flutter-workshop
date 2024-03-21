import 'package:flutter_workshop/features/trips/data/datasources/local/trip.local.datasource.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';

class TripRepository {
  final TripLocalDataSource localDataSource;

  TripRepository({required this.localDataSource});

  void addTrip(Trip trip) {
    localDataSource.addTrip(trip);
  }

  List<Trip> getTrips() {
    return localDataSource.getTrips();
  }
}
