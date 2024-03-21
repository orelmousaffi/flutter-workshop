# flutter_workshop

Here you'll find the completed code for session 1 of the workshop

## Session #1 Instructions

### Main Screen and Bottom Navigation

We will be creating a Trips App that allows the user to add their upcoming trips and display them in a list.

1. We'll first create the main page of our app, it has a bottom navigation bar with two tabs: `My Trips` and `Add Trips`. Let's create a folder in `lib/features/trips/screens/main` for `main.screen.dart`.
2. Define `MainScreen` widget as just an empty widget for now.

```dart
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
```

4. Erase the code for `MyApp` in `main.dart` and set the title of the app to `Travel App` and the home to the `MainScreen` widget we just created. If you run the app you should see an empty screen (`MainScreen`).

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      home: const MainScreen(),
    );
  }
}
```

5. Define some constants. We'll have 2 pages for our app: `My Trips` page and `Add Trips` page. We can define them as an enum `TripPage` in `constants/trip.constants.dart` along with their labels and icons (for bottom navigation), this is for easy identification of the page elements.

```dart
enum TripPage {
  myTrips('My Trips', Icons.list),
  addTrips('Add Trip', Icons.add);

  final String label;
  final IconData icon;

  const TripPage(this.label, this.icon);
}
```

6. Create two blank widgets that we will use for `My Trips` page and `Add Trips` page, feel free to just copy from `MainScreen` for now.

```dart
class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
```

7. The `build()` method can be called many times during the app's run, so it's not good to keep track of information here. In order to safely keep track of information such as which page we're on, we need to change our main screen to a stateful widget.

```dart
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
```

8. Define our state: we need to keep track of the `_currentPage`. On app start we want to show the `My Trips` screen, so we can define it as the first value in our `TripPage` enum (Dart translates enums to their indices, so the order is reserved).

```dart
class _MainScreenState extends State<MainScreen> {
  TripPage _currentPage = TripPage.values[0];

  @override
  Widget build(BuildContext context) {
    ...
  }
}
```

9. Let's add an `AppBar` that shows the name of the page we're on, instead of the empty widget, let's use a `Scaffold` which you can consider as a screen. We'll still keep the body as the empty widget before, but let's add an `AppBar` to the `Scaffold` with the title being the `_currentPage`'s label

```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            _currentPage.label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: const SizedBox.shrink(),
    );
  }
```

10. We want to add a bottom navigation bar and the actual pages to the `Scaffold`, let's define how to create those in our `TripPage` enum.

```dart
enum TripPage {
  ...

  BottomNavigationBarItem getBottomNavigationBarItem() {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

  Widget getScreen() {
    switch (this) {
      case myTrips:
        return const MyTripsScreen();
      case addTrips:
        return const AddTripScreen();
    }
  }
}
```

11. In our `MainScreen`'s state object, let's grab those bottom navigation items and the pages

```dart
  final _bottomNavItems =
      TripPage.values.map((e) => e.getBottomNavigationBarItem()).toList();
  final _pages = TripPage.values.map((e) => e.getScreen()).toList();
```

12. We can now add a `BottomNavigationBar` to our `Scaffold`

```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
        ...
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage.index,
          items: _bottomNavItems,
          onTap: (pageIndex) {
            // TODO change the page
          },
        ));
  }
```

13. To control which page we show, we need to create a `PageController`, let's create it in the state object and now we can show the body of the `Scaffold` as a `PageView` controlled by the `_pageController`

```dart
class _MainScreenState extends State<MainScreen> {
  ...
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        ...
        body: PageView(controller: _pageController, children: _pages),
        ...
        );
  }
}
```

14. Whenever user taps the bottom navigation item, we want to change page. Add onTap callback to the `BottomNavigationBar` widget to handle `setState()` (This forces a rebuild of the widget with the updated state) with changing the page with `_pageController` and updating the value for `_currentPage`

```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
        ...
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage.index,
          items: _bottomNavItems,
          onTap: (pageIndex) {
            setState(() {
              _pageController.jumpToPage(pageIndex);
              _currentPage = TripPage.values[pageIndex];
            });
          },
        )
      );
  }
```

15. We also need to change our state (`_currentPage`) whenever the page controller detects a change (user swiped between pages), so we need to add a listener to the `_pageController` and update `_currentPage` whenever there is an update. However, since `build()` can be called many times, we shouldn't add listeners in the `build()` method. Instead, we can override `initState()` as it's only called once for the state object. In `initState()`, add listener to the page controller to `setState()` whenever page changes. `setState()` changes the state and forces a rebuild, which changes the view base on the new state. With this we have a functional two page app with bottom navigation. Next we'll start writing the `Add Trips` page

```dart
  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = TripPage.values[_pageController.page!.round()];
      });
    });
  }
```

### Add Trips From

1. We will be using the `flutter_form_builder` and `form_builder_validators` packages. Add the following packages with the version below to your `pubspec.yaml` file. VS Code should detect the changes and install this automatically for you.

`flutter_form_builder` - flutter_form_builder is a Flutter package that simplifies user input by eliminating most of the boilerplate needed to build a form, validate fields, react to changes, and collect the final form input.

`flutter_builder_validators` - Form Builder Validators set of validators for any FormField widget or widgets that extend the FormField class - e.g., TextFormField, DropdownFormField, et cetera. It provides standard ready-made validation rules and a way to compose new validation rules combining multiple rules, including custom ones.

```yaml
flutter_form_builder: 9.1.0
form_builder_validators: ^9.0.0
```

2. Now that we have our form dependencies listed, let's list each of the form fields that we'll use when creating a trip in our application. First, let's define the enums that we'll use to define the fields collected and the placeholders on each field. Add the following to the `trip.constants.dart` file:

```dart
enum AddTripForm {
  title('title', 'Title'),
  description('description', 'Description'),
  location('location', 'Location'),
  photoURL('photo_url', 'Photo URL');

  final String name;
  final String label;

  const AddTripForm(this.name, this.label);
}
```

3. Using the `enums` that we just created, let's list out the form field widgets that will compose our form. We'll do this with a collection of `FormBuilderTextField` widgets. Notice that we are using the `FormBuilderValidators` widget to apply validation. Let's be sure to include this in the context of the `build()` method, because when the form is controlled, the `onChange()` event listener will need to call an instance method to function properly.

```dart
FormBuilderTextField(
  name: AddTripForm.title.name,
  decoration: InputDecoration(labelText: AddTripForm.title.label),
  validator: FormBuilderValidators.required(),
),
... list out title, description, and location
```

4. Before we add any more fields to the form, let's add this to the rendered widget and see what we've built:

```dart
@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: FormBuilder(
        child: Column(
      children: [...formFields],
    )),
  );
}
```

5. Now we have 3 text fields that are required, but we also what to enter the date of our trip. To do this we'll use the `FormBuilderDateTimePicker` widget like so. Within the widget we are going to set the initial date, and then the valid range of available dates. We will also implement a custom validator for this field to ensure we get a valid date.

```dart
FormBuilderDateTimePicker(
  name: AddTripForm.date.name,
  decoration: InputDecoration(labelText: AddTripForm.date.label),
  initialDate: DateTime.now().add(const Duration(days: 15)),
  firstDate: DateTime.now().add(const Duration(days: 15)),
  lastDate: DateTime.now().add(const Duration(days: 299)),
  validator: (DateTime? dateTime) {
    if (dateTime == null) {
      return 'Date is required';
    }
    return null; // Return null if validation succeeds
  },
),
```

6. The last field we want to list is the Photo URL. The Photo URL will be a `FormBuilderTextField` like before, but in this case, we want to use a combination of validators for the input. For this we'll use a helper function from `FormBuilderValidators` like shown below:

```dart
FormBuilderTextField(
  name: AddTripForm.photoURL.name,
  decoration: InputDecoration(labelText: AddTripForm.photoURL.label),
  validator: FormBuilderValidators.compose(
      [FormBuilderValidators.required(), FormBuilderValidators.url()]),
),
```

7. Now that we have our form built, let's add a button at the bottom that we can press to submit the form.

```dart
// FormBuilder > Column : children
children: [
  ...formFields,
  const SizedBox(height: 32.0),
  MaterialButton(
    color: Theme.of(context).colorScheme.primary,
    onPressed: () {},
    child: const Text(
      'Create Trip',
      style: TextStyle(color: Colors.white),
    ),
  )
],
```

8. At this stage, our form contains all the necessary fields, but lacks the capability to track user input or perform validation on the entered data. To accomplish this we'll use a `Notifier` to control the form. A notifier serves as a centralized state manager for the form, responsible for tracking input values, validation status, and other form-related state. When the state is updated within the notifier, all widgets that are listening to that particular notifier trigger a rebuild. For a developer that is familiar with React, this is similar to the concept of Context API.

To implement the `Notifier` we will use the `Riverpod` framework. Riverpod is a state management framework for Flutter, which is inspired by the `Provider` package and built on top of the Flutter's Provider package. It aims to provide a more robust, simplified, and predictable way of managing state in Flutter applications. Conceptually, the use of a `Provider` is simplify an implementation of Dependency Injection.

Run the following command to add `riverpod` to your project:

```bash
flutter pub add flutter_riverpod
```

9. Wrap the application at the root to use a `ProviderScope`.
10. Update the `AddTripScreen` to be a Riverpod `ConsumerWidget`:

```dart
class AddTripScreen extends ConsumerStatefulWidget {
  const AddTripScreen({super.key});

  @override
  ConsumerState<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends ConsumerState<AddTripScreen> {
... logic
}
```

11. Using the `Riverpod Notifier` to build out a `AddTripController` that tracks the state of the `Add Trip` form. In this step, we'll also define the `addTripControllerProvider` that exposes the controller.

```dart
// addTrip.controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTripState {
  final String? title;
  final String? description;
  final String? location;
  final String? photoURL;
  final DateTime? date;

  AddTripState(
      this.title, this.description, this.location, this.photoURL, this.date);
}

class AddTripController extends Notifier<AddTripState> {
  @override
  AddTripState build() => AddTripState(null, null, null, null, null);
}

final addTripControllerProvider =
    NotifierProvider<AddTripController, AddTripState>(AddTripController.new);
```

12. Now we have a notifier and provider to mange the state of the form, but we don't have any methods that will actually listen or set changes to the state. Let's add these listeners to the controller. First let's write a function to update the state based on the field that has changed. Any updatedField will be set to state, otherwise the current state is used for rebuilding the state object.

```dart
void updateFields(Map<String, dynamic> updatedFields) {
    // Create a new AddTripState based on the existing state
    state = AddTripState(
      updatedFields['title'] ?? state.title,
      updatedFields['description'] ?? state.description,
      updatedFields['location'] ?? state.location,
      updatedFields['photoURL'] ?? state.photoURL,
      updatedFields['date'] ?? state.date,
    );
  }
```

13. To invoke the `updateFields` method, we need a helper function that only provides the updated field, while leaving the rest of the state attributes `null` so that the `updateFields` know to keep current state value. Let;s write a helper function to accomplish this:

```dart
void handleFieldChange(String fieldName, dynamic newValue) {
  // Create a map to hold the updated fields
  Map<String, dynamic> updatedFields = {};
  // Set the updated field in the map
  updatedFields[fieldName] = newValue;

  // Update the fields in the state using the controller
  ref.read(addTripControllerProvider.notifier).updateFields(updatedFields);
}
```

14. Invoke the helper function in each of the change handlers on the `FormBuilder` fields. For example:

```dart
FormBuilderTextField(
  name: AddTripForm.title.name,
  decoration: InputDecoration(labelText: AddTripForm.title.label),
  validator: FormBuilderValidators.required(),
  onChanged: (String? newValue) {
    handleFieldChange('title', newValue);
  },
),
```

15. For the final steps, let's add a `GlobalKey` to the form so that `FormBuilder` can track the state using the controller we defined above, and implement a bit of logic that just prints out the submitted fields once validated. At the top of the `_AddTripScreenState` state, let's initialize a form key, and then add it to the form like so:

```dart
final _formKey = GlobalKey<FormBuilderState>();

// Inside FormBuilder widget
key: _formKey,
```

16. Implement the `onPress` handler for the event listener and add it to the submit button.

```dart
void handleOnPress() {
  if (_formKey.currentState?.saveAndValidate() ?? false) {
    var formState = _formKey.currentState;

    if (formState != null) {
      formState.fields.forEach((key, field) {
        var value = field.value;
        print("$key: $value");
      });
    }
  }
}

// add to the submit button
onPressed: handleOnPress
```

## 