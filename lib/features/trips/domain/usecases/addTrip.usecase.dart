import 'package:dartz/dartz.dart';
import 'package:flutter_workshop/types/tripErrors.types.dart';
import 'package:flutter_workshop/features/trips/domain/entities/trip.entity.dart';
import 'package:flutter_workshop/features/trips/domain/repositories/trip.repository.dart';

class AddTrip {
  final TripRepository repository;

  AddTrip({required this.repository});

  Future<Either<TripError, Trip>> call(Trip trip) {
    return repository.addTrip(trip);
  }
}
