abstract class TripError {
  final String message;

  TripError(this.message);
}

class GetTripsError extends TripError {
  static const String errorMessage =
      'Something went wrong when trying to get your trips. Please try again.';

  GetTripsError() : super(errorMessage);
}

class DeleteTripError extends TripError {
  final int index;
  static String errorMessage =
      'Something when wrong when deleting trip at unknown index';

  DeleteTripError(this.index) : super(errorMessage) {
    errorMessage = 'Something when wrong when deleting trip at index: $index';
  }
}

class AddTripError extends TripError {
  static String errorMessage =
      'Something went wrong when adding your trip. Please try again';

  AddTripError() : super(errorMessage);
}
