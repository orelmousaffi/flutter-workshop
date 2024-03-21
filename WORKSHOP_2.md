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

1. We learned last time that a `Notifier` in flutter is used as a centralized store for us to store state. So let's go ahead and create a `Notifier` that will interface with the repository and manage the sate of the data we are loading from local storag. Create the notifier file `trip.notifier.dart` under `lib/features/trips/providers`:

```dart
class TripNotifier extends StateNotifier<List<Trip>> {
  List<Trip>? trips;
  TripRepository repository;

  TripNotifier(this.trips, this.repository) : super(repository.getTrips());
}
```

Notice how we initialize the `super` constructor with the results form the repository. This way we always load the data from local storage by default.

2. Let's add some functions to our notifier to get and set data. Create an `addTrip()` function that adds a trip to the repository and saves to state, and `getTrips()` which loads to state like so:

```dart
void addTrip(Trip trip) {
  repository.addTrip(trip);
  state = repository.getTrips();
}

void getTrips() {
  state = repository.getTrips();
}
```

3. Now that we have a `Notifier` to manage our data, let's create the necessary `Providers` to expose it. Create a file call `trip.provider.dart` under `lib/features/trips/providers`, now let's create 3 providers:
   1. A provider for the local data source for the repository to use.
   2. A provider for the repository so that the notifier can use.
   3. A provider for the notifier for any consumer outside can use.

```dart
final tripLocalDataSourceProvider = Provider<TripLocalDataSource>((ref) {
  final Box<Trip> tripBox = Hive.box('trips');
  return TripLocalDataSource(tripBox: tripBox);
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final localDataSource = ref.read(tripLocalDataSourceProvider);
  return TripRepository(localDataSource: localDataSource);
});

final tripNotifierProvider =
    StateNotifierProvider<TripNotifier, List<Trip>>((ref) {
  final tripRepository = ref.read(tripRepositoryProvider);
  return TripNotifier(tripRepository.getTrips(), tripRepository);
});
```

4. We now have a `Notifier` to manage our state, and a `Proivder` to expose that state store; let's actually add some data to the repository with the form controller we build last time. In the `addTrip.controller.dart` under `lib/features/trips/screens/addTrip` folder, let's add a function to add trips:

```dart
  void addTrip() {
    final Trip trip = Trip(
        title: state.title ?? '',
        photo: state.photoURL ?? '',
        description: state.description ?? '',
        date: state.date ?? DateTime.now().add(const Duration(days: 15)),
        location: state.location ?? '');

    ref.read(tripNotifierProvider.notifier).addTrip(trip);
  }
```

In addition to this, update the `handleOnPress()` in the screen file to call this notifier function:

```dart
  void handleOnPress() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      ref.read(addTripControllerProvider.notifier).addTrip();
    }
  }
```

5. Now that we have data validated on our form and added to local storage, let's load it on the `MyTrips` page. Open the `myTrips.screen.dart` screen and first update the Widget definition to be a `ConsumerWidget` so that we can consume our Provider like so:

```dart
class MyTripsScreen extends ConsumerWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }
}
```

6. Now define a local variable to retrieve our trips from the `tripNotifierProvider` we defined earlier. Notice how here we are using `watch`, this allows ups to watch for changes in the trips variable.

```dart
final List<Trip> trips = ref.watch(tripNotifierProvider)
```

7. Now we are expecting a number of different trips once we keep adding data, therefore we need to list these trips in a `ListView`. Let's create a `ListView` builder that will list our each of our trips, and then we can handle each state; when we have data, and when we don't. For now the `itemBuilder` is returning an empty `SizedBox`, but we'll update soon.

```dart
    Widget itemBuilder(BuildContext context, int index) {
      return SizedBox();
    }

    return ListView.builder(itemCount: trips.length, itemBuilder: itemBuilder);
```

8. Now if we run our app, we still don't see anything, and this because we don't have any data to display. So let's return something meaningful when there is no data to display like so. This should be inserted before the `return` statement of the `itemBuilder`.

```dart
if (trips.isEmpty) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Text('No trips found'),
    ),
  );
}
```

9. Let's start building out the trips we want to list on the screen. So to start off, we're going to the following formatting:
   - Create a `Padding` widget so that we can have 16 pixels of padding around the entire list.
   - Create a `Wrap` widget so that we can list multiple child widgets vertically aligned.

```dart
return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Wrap(
      direction: Axis.vertical,
      spacing: 5,
      children: [],
    ));
```

10. Now let's wrap up the demo by listing all the trip attributes and displaying the image from the URL provided.

```dart