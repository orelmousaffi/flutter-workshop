# flutter_workshop

Here you'll find the completed code for session 2 of the workshop

## Session #2 Instructions

### Creating local storage
Previously we created a form to add trips, now it's time to store the trips locally

1. Add `hive`, `hive_flutter`, `path_provider` as dependencies, you can either cmd+shift+p and add flutter dependencies, or add the following as part of dependencies under pubspec.yaml
```yaml
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.2
```
Add `hive_generator` dependency under dev_dependencies:
```yaml
  hive_generator: ^2.0.1
```

2. Create our model under `features/trips/data/models`, let's name is `trip.model.dart`
```dart
import 'package:hive/hive.dart';

part 'trip.model.g.dart';

@HiveType(typeId: 0)
class Trip {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String photo;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String location;

  Trip({
    required this.title,
    required this.photo,
    required this.description,
    required this.date,
    required this.location,
  });
}
```
To store an object in local storage (hive), we need to annotate the class and its attributes with @HiveType and @HiveField
Also notice `part 'trip.model.g.dart'`, this is to indicate to the build runner to generate code for this class to work with hive

3. Open command line on the base folder of the project and run `flutter packages pub run build_runner build`, this will generate the hive class for the object

4. On app launch, we want to initialize hive and open our collection of trips, we can do that in `main.dart` 
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Hive
  Hive.registerAdapter(TripAdapter());

  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox<Trip>('trips');

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}
```
`registerAdapter` allows hive to understand the object we're storing. `TripAdapter` is generated from `Trip` earlier.
We `initFlutter` using `getApplicationDocumentsDirectory`, which is fetched using `path_provider` library that we added earlier.
Lastly, we open the `Trip` box which contains the trips we stored (which is nothing currently)

5. Next, let's define our `trip.local.datasource.dart` under `features/trips/data/datasources/local`
```dart
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:hive/hive.dart';

class TripLocalDataSource {
  final Box<Trip> tripBox;

  TripLocalDataSource({required this.tripBox});

  List<Trip> getTrips() {
    return tripBox.values.toList();
  }

  void addTrip(Trip trip) {
    tripBox.add(trip);
  }
}
```
It has one dependency of the trip box and uses it to get or add trips. In the future we'll have a remote data source to fetch from an API as well, but for now we just need the local data source to save to hive.

6. Now let's define our `trip.repository.dart` under `features/trips/domain/repositories`
```dart
import 'package:flutter_workshop/features/trips/data/datasources/local/trip.local.datasource.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';

class TripRepository {
  final TripLocalDataSource localDataSource;

  TripRepository({required this.localDataSource});

  void addTrip(Trip trip) {
    localDataSource.addTrip(trip);
  }

  List<Trip> getTrips() {
    return localDataSource.getTrips();
  }
}
```
Similar to the local data source, we have the data source as a dependency and it calls the data source to add/get trips.

Now we're ready to connect our functionalities to the screen actions!

### Adding and Fetching trips from local storage and display
