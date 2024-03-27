import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/features/trips/data/datasources/local/trip.local.datasource.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:flutter_workshop/features/trips/domain/repositories/trip.repository.dart';
import 'package:flutter_workshop/features/trips/providers/trip.notifier.dart';
import 'package:hive/hive.dart';

final tripLocalDataSourceProvider = Provider<TripLocalDataSource>((ref) {
  final Box<Trip> tripBox = Hive.box('trips');
  return TripLocalDataSource(tripBox: tripBox);
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final localDataSource = ref.read(tripLocalDataSourceProvider);
  return TripRepository(
    localDataSource: localDataSource,
  );
});

final tripNotifierProvider =
    StateNotifierProvider<TripNotifier, List<Trip>>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return TripNotifier(repository.getTrips(), repository);
});
