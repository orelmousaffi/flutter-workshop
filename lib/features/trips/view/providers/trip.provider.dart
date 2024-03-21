import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/features/trips/data/datasources/local/trip.local.datasource.dart';
import 'package:flutter_workshop/features/trips/data/datasources/remote/trip.remote.datasource.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:flutter_workshop/features/trips/data/repositories/trip.repository.dart';
import 'package:flutter_workshop/features/trips/domain/entities/trip.entity.dart';
import 'package:flutter_workshop/features/trips/domain/usecases/addTrip.usecase.dart';
import 'package:flutter_workshop/features/trips/domain/usecases/deleteTrip.usecase.dart';
import 'package:flutter_workshop/features/trips/domain/usecases/getTrips.usecase.dart';
import 'package:flutter_workshop/features/trips/view/providers/trip.notifier.dart';
import 'package:hive/hive.dart';

final tripRemoteDataSourceProvider = Provider<TripRemoteDataSource>((ref) {
  final Dio dio = Dio();
  return TripRemoteDataSource(dio: dio);
});

final tripLocalDataSourceProvider = Provider<TripLocalDataSource>((ref) {
  final Box<TripModel> tripBox = Hive.box('trips');
  return TripLocalDataSource(tripBox: tripBox);
});

final tripDataRepositoryProvider = Provider<TripDataRepository>((ref) {
  final localDataSource = ref.read(tripLocalDataSourceProvider);
  final remoteDataSource = ref.read(tripRemoteDataSourceProvider);
  return TripDataRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

final addTripProvider = Provider<AddTrip>((ref) {
  final repository = ref.read(tripDataRepositoryProvider);
  return AddTrip(repository: repository);
});

final getTripsProvider = Provider<GetTrips>((ref) {
  final repository = ref.read(tripDataRepositoryProvider);
  return GetTrips(repository: repository);
});

final deleteTripProvider = Provider<DeleteTrip>((ref) {
  final repository = ref.read(tripDataRepositoryProvider);
  return DeleteTrip(repository: repository);
});

final tripNotifierProvider =
    StateNotifierProvider<TripNotifier, List<Trip>>((ref) {
  final getTrips = ref.read(getTripsProvider);
  final addTrip = ref.read(addTripProvider);
  final deleteTrip = ref.read(deleteTripProvider);

  return TripNotifier(null, getTrips, addTrip, deleteTrip);
});
