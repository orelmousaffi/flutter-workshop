import 'package:dartz/dartz.dart';
import 'package:flutter_workshop/types/tripErrors.types.dart';
import 'package:flutter_workshop/features/trips/data/datasources/local/trip.local.datasource.dart';
import 'package:flutter_workshop/features/trips/data/datasources/remote/trip.remote.datasource.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:flutter_workshop/features/trips/domain/entities/trip.entity.dart';
import 'package:flutter_workshop/features/trips/domain/repositories/trip.repository.dart';
import 'package:intl/intl.dart';

class TripDataRepository implements TripRepository {
  final TripLocalDataSource localDataSource;
  final TripRemoteDataSource remoteDataSource;

  TripDataRepository(
      {required this.localDataSource, required this.remoteDataSource});

  @override
  Future<Either<TripError, Trip>> addTrip(Trip trip) async {
    try {
      final forecast = await remoteDataSource.getWeather7days(
          trip.location, DateFormat("yyyy-MM-dd").format(trip.date));
      final tripModel = TripModel.fromEntity(trip, forecast);
      localDataSource.addTrip(tripModel);

      return Right(tripModel.toEntity());
    } catch (error) {
      return Left(AddTripError());
    }
  }

  @override
  Future<Either<TripError, bool>> deleteTrip(int index) async {
    try {
      localDataSource.deleteTrip(index);
      return const Right(true);
    } catch (error) {
      return Left(DeleteTripError(index));
    }
  }

  @override
  Future<Either<TripError, List<Trip>>> getTrips() async {
    try {
      final tripModels = localDataSource.getTrips();
      List<Trip> trips =
          tripModels.map((tripModel) => tripModel.toEntity()).toList();

      return Right(trips);
    } catch (error) {
      return Left(GetTripsError());
    }
  }
}
