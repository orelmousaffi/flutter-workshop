// ignore_for_file: non_constant_identifier_names, constant_identifier_names

class TripPage {
  final String label;
  final int index;

  TripPage({required this.label, required this.index});
}

class TripFormField {
  final String name;
  final String label;

  TripFormField({required this.name, required this.label});
}

class TripPages {
  static TripPage MY_TRIPS = TripPage(label: 'My Trips', index: 0);
  static TripPage ADD_TRIPS = TripPage(label: 'Add Trip', index: 1);
}

class AddTripForm {
  static TripFormField TITLE = TripFormField(name: 'title', label: 'Title');
  static TripFormField DESCRIPTION =
      TripFormField(name: 'description', label: 'Description');
  static TripFormField LOCATION =
      TripFormField(name: 'location', label: 'Location');
  static TripFormField PHOTO = TripFormField(name: 'photo', label: 'Photo');
}

enum ToastStatus { success, error, info }

// Successful / Static Messages
const String NO_TRIP_FOUND = 'There are no trips to display';
const String TRIP_SUCCESSFULLY_DELETED = 'The trip was successfully deleted.';
const String TRIP_SUCCESSFULLY_ADDED = 'The trip was successfully added.';
const String CREATE_TRIP_LABEL = 'Create Trip';

// Error Messages
const String ERROR_DELETING_TRIP = 'An error occurred, trip was not deleted.';
const String ERROR_ADDING_TRIP = 'An error occurred, trip was not added.';
