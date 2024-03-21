import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/features/trips/domain/entities/trip.entity.dart';
import 'package:flutter_workshop/features/trips/domain/usecases/addTrip.usecase.dart';
import 'package:flutter_workshop/features/trips/domain/usecases/deleteTrip.usecase.dart';
import 'package:flutter_workshop/features/trips/domain/usecases/getTrips.usecase.dart';

class TripNotifier extends StateNotifier<List<Trip>> {
  List<Trip>? trips;

  final GetTrips _getTrips;
  final AddTrip _addTrip;
  final DeleteTrip _deleteTrip;

  TripNotifier(this.trips, this._getTrips, this._addTrip, this._deleteTrip)
      : super([]);

  Future<bool> addNewTrip(Trip trip) async {
    Trip? tripResult;
    final result = await _addTrip(trip);
    result.fold((error) => tripResult = null, (result) => tripResult = result);

    if (tripResult != null) {
      trips?.add(tripResult!);
      updateState();
    }

    return tripResult != null;
  }

  Future<bool> removeTrip(int index) async {
    var isDeleted = false;
    final result = await _deleteTrip(index);
    result.fold((error) => isDeleted = false,
        (isSuccessful) => isDeleted = isSuccessful);

    if (isDeleted) {
      trips?.removeAt(index);
      updateState();
    }

    return isDeleted;
  }

  Future<void> loadTrips() async {
    if (trips == null) {
      final result = await _getTrips();
      result.fold((error) => trips = [], (loadedTrips) => trips = loadedTrips);
      updateState();
    }
  }

  void updateState() {
    if (trips != null) {
      state = [...?trips];
    }
  }
}
