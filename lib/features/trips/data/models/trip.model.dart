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
