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

  @override
  AddTripState build() => AddTripState(null, null, null, null, null);
}

final addTripControllerProvider =
    NotifierProvider<AddTripController, AddTripState>(AddTripController.new);
