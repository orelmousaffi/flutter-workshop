import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:flutter_workshop/features/trips/domain/repositories/trip.repository.dart';

class TripNotifier extends StateNotifier<List<Trip>> {
  List<Trip>? trips;
  TripRepository repository;

  TripNotifier(this.trips, this.repository) : super(repository.getTrips());

  void addNewTrip(Trip trip) {
    repository.addTrip(trip);
    state = repository.getTrips();
  }

  void getTrips() {
    state = repository.getTrips();
  }
}
