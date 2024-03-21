import 'package:dartz/dartz.dart';
import 'package:flutter_workshop/types/tripErrors.types.dart';
import 'package:flutter_workshop/features/trips/domain/repositories/trip.repository.dart';

class DeleteTrip {
  final TripRepository repository;

  DeleteTrip({required this.repository});

  Future<Either<TripError, bool>> call(int tripId) {
    return repository.deleteTrip(tripId);
  }
}
