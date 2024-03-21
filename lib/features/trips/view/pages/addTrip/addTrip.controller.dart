import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/features/trips/domain/entities/trip.entity.dart';
import 'package:flutter_workshop/features/trips/view/providers/trip.provider.dart';

class AddTripState {
  final String? title;
  final String? description;
  final String? location;
  final String? photo;
  final DateTime? date;

  AddTripState(
      this.title, this.description, this.location, this.photo, this.date);
}

class AddTripController extends Notifier<AddTripState> {
  Future<bool> addTrip(WidgetRef ref) async {
    final Trip trip = Trip(
        title: state.title ?? '',
        photos: [state.photo ?? ''],
        description: state.description ?? '',
        date: state.date ?? DateTime.now().add(const Duration(days: 15)),
        location: state.location ?? '');

    final isAdded =
        await ref.read(tripNotifierProvider.notifier).addNewTrip(trip);

    if (isAdded) {
      ref.read(tripNotifierProvider.notifier).loadTrips();
      ref.invalidate(addTripControllerProvider);
    }

    return isAdded;
  }

  void updateTitle(String? title) {
    state = AddTripState(
        title, state.description, state.location, state.photo, state.date);
  }

  void updateDescription(String? description) {
    state = AddTripState(
        state.title, description, state.location, state.photo, state.date);
  }

  void updateLocation(String? location) {
    state = AddTripState(
        state.title, state.description, location, state.photo, state.date);
  }

  void updatePhoto(String? photo) {
    state = AddTripState(
        state.title, state.description, state.location, photo, state.date);
  }

  void updateDate(DateTime? dateTime) {
    state = AddTripState(
        state.title, state.description, state.location, state.photo, dateTime);
  }

  @override
  AddTripState build() => AddTripState(null, null, null, null, null);
}

final addTripControllerProvider =
    NotifierProvider<AddTripController, AddTripState>(AddTripController.new);
