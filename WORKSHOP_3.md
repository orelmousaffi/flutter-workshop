# flutter_workshop

Here you'll find the completed code for session 2 of the workshop

## Session #3 Instructions

### Fetch weather data from API
Previously we stored trip data in local database, now let's add some API data as well!
We've modified `Trip` model to include weather info, and also added the API key needed for weather API in `features/trips/network/weather.config.dart`.
Let's get started!

1. Add dependency for our network library Dio.
```yaml
  dio: ^5.4.1
```

2. Let's create the remote database for fetching weather API data under `features/trips/data/datasources/remote`.
```dart
import 'package:dio/dio.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:flutter_workshop/features/trips/network/weather.config.dart';

class TripRemoteDataSource {
  Dio dio;

  TripRemoteDataSource({required this.dio});

  Future<Forecast> getWeather7days(String location, String date) async {
    final response = await dio.get(
        "https://api.weatherapi.com/v1/future.json?key=$WEATHER_API_KEY&q=$location&dt=$date");
    return Forecast.fromMap(response.data);
  }
}
```

3. Modify our repository and add remote data source as a dependency, then we can get weather data as part of our add trip call and save it in the database.
Note since we are adding an API call, `addTrip` is now an async call.
```dart
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
```

4. We also need to modify our provider for repository to include the remote data base we just added
```dart
final tripRemoteDataSourceProvider = Provider<TripRemoteDataSource>((ref) {
  final Dio dio = Dio();
  return TripRemoteDataSource(dio: dio);
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final localDataSource = ref.read(tripLocalDataSourceProvider);
  final remoteDataSource = ref.read(tripRemoteDataSourceProvider);
  return TripRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});
```

5. Modify our notifier to get updated trips AFTER the add is complete
```dart
class TripNotifier extends StateNotifier<List<Trip>> {
  List<Trip>? trips;
  TripRepository repository;

  TripNotifier(this.trips, this.repository) : super(repository.getTrips());

  void addNewTrip(Trip trip) {
    repository.addTrip(trip).then((value) => state = repository.getTrips());
  }

  void getTrips() {
    state = repository.getTrips();
  }
}
```

6. Now that we have all the weather data hooked up, let's modify our view to display it. In `TravelCard.widget.dart`, let's display the weather data in a grid
```dart
class TravelCard extends StatelessWidget {
  ...
    Card buildCard() {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...
          GridView.count(
            primary: false,
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: 5,
            shrinkWrap: true,
            children: trip.forecast?.forecastDay.first.hours
                    .where((element) => element.time.hour % 3 == 0)
                    .map(
                      (hour) => Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        color: Colors.teal[100],
                        child: Text(
                            '${DateFormat('h a').format(hour.time)}\n${hour.temp_f}F'),
                      ),
                    )
                    .toList() ??
                [],
          ),
        ]
      );
    }
  ...
}
```

Uninstall the app (since we've modified our models) and reinstall, add a new trip and see the weather data appear!
