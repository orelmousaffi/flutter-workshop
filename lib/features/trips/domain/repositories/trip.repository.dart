import 'package:flutter_workshop/types/tripErrors.types.dart';
import 'package:flutter_workshop/features/trips/domain/entities/trip.entity.dart';
import 'package:dartz/dartz.dart';

abstract class TripRepository {
  Future<Either<TripError, List<Trip>>> getTrips();
  Future<Either<TripError, bool>> deleteTrip(int tripId);
  Future<Either<TripError, Trip>> addTrip(Trip trip);
}
