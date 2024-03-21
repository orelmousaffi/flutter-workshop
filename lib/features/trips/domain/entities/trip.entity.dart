import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';

class Trip {
  final String title;
  final List<String> photos;
  final String description;
  final DateTime date;
  final String location;
  final Forecast? forecast;

  Trip({
    required this.title,
    required this.photos,
    required this.description,
    required this.date,
    required this.location,
    this.forecast,
  });
}
