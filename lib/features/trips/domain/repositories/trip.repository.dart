import 'package:flutter_workshop/features/trips/data/datasources/local/trip.local.datasource.dart';
import 'package:flutter_workshop/features/trips/data/datasources/remote/trip.remote.datasource.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:intl/intl.dart';

class TripRepository {
  final TripLocalDataSource localDataSource;
  final TripRemoteDataSource remoteDataSource;

  TripRepository(
      {required this.localDataSource, required this.remoteDataSource});

  Future<void> addTrip(Trip trip) async {
    final forecast = await remoteDataSource.getWeather7days(
        trip.location, DateFormat("yyyy-MM-dd").format(trip.date));
    final tripModel = trip.copyWithForecast(forecast);
    return localDataSource.addTrip(tripModel);
  }

  List<Trip> getTrips() {
    return localDataSource.getTrips();
  }
}
