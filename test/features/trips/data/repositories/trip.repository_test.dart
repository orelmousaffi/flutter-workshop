import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/features/trips/data/datasources/local/trip.local.datasource.dart';
import 'package:flutter_workshop/features/trips/data/datasources/remote/trip.remote.datasource.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:flutter_workshop/features/trips/data/repositories/trip.repository.dart';
import 'package:flutter_workshop/features/trips/domain/entities/trip.entity.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

class MockTripLocalDataSource extends Mock implements TripLocalDataSource {}

class MockTripRemoteDataSource extends Mock implements TripRemoteDataSource {}

void main() {
  group('TripDataRepository', () {
    final mockTripLocalDataSource = MockTripLocalDataSource();
    final mockTripRemoteDataSource = MockTripRemoteDataSource();
    final repository = TripDataRepository(
        localDataSource: mockTripLocalDataSource,
        remoteDataSource: mockTripRemoteDataSource);
    test('addTrip', () async {
      final date = DateTime.now();
      final dateString = DateFormat("yyyy-MM-dd").format(date);
      final forcast = Forecast(forecastDay: [
        ForecastDay(
            date: dateString,
            day: Day(maxtemp_f: 11, mintemp_f: 12, avgtemp_f: 11.5),
            hours: [])
      ]);
      registerFallbackValue(TripModel(
          title: 'title',
          photos: ['photo'],
          description: 'description',
          date: date,
          location: 'location',
          forecast: forcast));
      when(() =>
              mockTripRemoteDataSource.getWeather7days('location', dateString))
          .thenAnswer((invocation) => Future.value(forcast));
      final trip = Trip(
          title: 'title',
          photos: ['photo'],
          description: 'description',
          date: date,
          location: 'location');

      await repository.addTrip(trip);

      verify(() =>
              mockTripRemoteDataSource.getWeather7days('location', dateString))
          .called(1);
      verify(() => mockTripLocalDataSource.addTrip(any())).called(1);
    });

    test('deleteTrip', () async {
      await repository.deleteTrip(0);

      verify(() => mockTripLocalDataSource.deleteTrip(0)).called(1);
    });

    test('getTrips', () async {
      final date = DateTime.now();
      final dateString = DateFormat("yyyy-MM-dd").format(date);
      final forcast = Forecast(forecastDay: [
        ForecastDay(
            date: dateString,
            day: Day(maxtemp_f: 11, mintemp_f: 12, avgtemp_f: 11.5),
            hours: [])
      ]);
      when(() => mockTripLocalDataSource.getTrips()).thenReturn([
        TripModel(
            title: 'title',
            photos: ['photo'],
            description: 'description',
            date: date,
            location: 'location',
            forecast: forcast)
      ]);

      final trips = (await repository.getTrips()).fold((l) => [], (r) => r);

      verify(() => mockTripLocalDataSource.getTrips()).called(1);
      expect(trips.length, 1);
      expect((trips.first as Trip).title, 'title');
    });
  });
}
