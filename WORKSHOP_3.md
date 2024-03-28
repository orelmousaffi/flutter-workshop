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

### Navigate back to MyTrips page

1. When we left off last time, we were able to add to local storage when adding a trip, but it wouldn't navigate back to the `MyTrips` page. Let's fix that. First make sure the `getScreen()` function in the `trip.constants.dart` file accepts a function called `navigateToPage` for us to use on the `AddTripScreen` page.

```dart
Widget getScreen(Function(int) navigateToPage) {
    switch (this) {
      case myTrips:
        return const MyTripsScreen();
      case addTrips:
        return AddTripScreen(navigateToPage: navigateToPage);
    }
  }
```

2. Now accept this function on the `AddTripScreen` constructor:

```dart
class AddTripScreen extends ConsumerStatefulWidget {
  const AddTripScreen({super.key, required this.navigateToPage});

  final void Function(int) navigateToPage;

  @override
  ConsumerState<AddTripScreen> createState() => _AddTripScreenState();
}
```

3. Next on the `main.screen.dart` page, make sure to pass the implementation of this function when setting the state of all the pages like so:

```dart
// Inside the initState()
_pages = TripPage.values
    .map((page) => page.getScreen((pageIndex) {
          _currentPage = page;
          _pageController.jumpToPage(pageIndex);
        }))
    .toList();
```

4. Finally update the `handleOnPress` function to invoke the method we passed in:

```dart
void handleOnPress() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      ref.read(addTripControllerProvider.notifier).addTrip();
      _formKey.currentState?.reset();
      widget.navigateToPage(TripPage.myTrips.index);
    }
  }
```

### Add Toast messages

1. First let's install the package used to show the toast messages [fluttertoast](https://pub.dev/packages/fluttertoast). To do this add the following dependency to the `pubspec.yaml` file. Make sure to save the file so that VS Code will add the package or run `flutter pub get` in the terminal.

```yaml
fluttertoast: ^8.2.4
```

2. Now let's go to the `addTrip.screen.dart` file and trigger a toast messages when the trip is added. First we initialize the flutter toast instance inside the `build()` function.

```dart
@override
Widget build(BuildContext context) {
  final FToast fToast = FToast();
  fToast.init(context);

// build method code...
}
```

3. Now let's move the `handlePress()` function down to the build context, create a toast message and trigger when pressing the create button.

```dart
void handleOnPress() {
  if (_formKey.currentState?.saveAndValidate() ?? false) {
    ref.read(addTripControllerProvider.notifier).addTrip();

    Widget toast = const ToastMessage(
        status: ToastStatus.success, message: 'Added Trip Successfully!');

    fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2));

    _formKey.currentState?.reset();
    widget.navigateToPage(TripPage.myTrips.index);
  }
}
```

### Delete Trip

1. To delete a trip, let's 
