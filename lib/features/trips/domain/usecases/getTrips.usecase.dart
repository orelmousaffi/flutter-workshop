import 'package:flutter_workshop/types/tripErrors.types.dart';
import 'package:flutter_workshop/features/trips/domain/entities/trip.entity.dart';
import 'package:flutter_workshop/features/trips/domain/repositories/trip.repository.dart';
import 'package:dartz/dartz.dart';

class GetTrips {
  final TripRepository repository;

  GetTrips({required this.repository});

  Future<Either<TripError, List<Trip>>> call() {
    return repository.getTrips();
  }
}
