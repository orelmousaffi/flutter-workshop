// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:flutter_workshop/features/trips/domain/entities/trip.entity.dart';

part 'trip.model.g.dart';

@HiveType(typeId: 0)
class TripModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final List<String> photos;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String location;
  @HiveField(5)
  final Forecast forecast;

  TripModel({
    required this.title,
    required this.photos,
    required this.description,
    required this.date,
    required this.location,
    required this.forecast,
  });

  factory TripModel.fromEntity(Trip trip, Forecast forecast) => TripModel(
        title: trip.title,
        photos: trip.photos,
        description: trip.description,
        date: trip.date,
        location: trip.location,
        forecast: forecast,
      );

  Trip toEntity() => Trip(
        title: title,
        photos: photos,
        description: description,
        date: date,
        location: location,
        forecast: forecast,
      );
}

@HiveType(typeId: 1)
class Forecast {
  @HiveField(0)
  List<ForecastDay> forecastDay;

  Forecast({
    required this.forecastDay,
  });

  factory Forecast.fromMap(Map<String, dynamic> map) {
    return Forecast(
      forecastDay: List<ForecastDay>.from(
        (map['forecast']['forecastday'] as List<dynamic>).map<ForecastDay>(
          (x) => ForecastDay.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory Forecast.fromJson(String source) =>
      Forecast.fromMap(json.decode(source) as Map<String, dynamic>);
}

@HiveType(typeId: 2)
class ForecastDay {
  @HiveField(0)
  String date;
  @HiveField(1)
  Day day;
  @HiveField(2)
  List<Hour> hours;

  ForecastDay({
    required this.date,
    required this.day,
    required this.hours,
  });

  factory ForecastDay.fromMap(Map<String, dynamic> map) {
    return ForecastDay(
      date: map['date'] as String,
      day: Day.fromMap(map['day'] as Map<String, dynamic>),
      hours: List<Hour>.from(
        (map['hour'] as List<dynamic>).map<Hour>(
          (x) => Hour.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory ForecastDay.fromJson(String source) =>
      ForecastDay.fromMap(json.decode(source) as Map<String, dynamic>);
}

@HiveType(typeId: 3)
class Day {
  @HiveField(0)
  double maxtemp_f;
  @HiveField(1)
  double mintemp_f;
  @HiveField(2)
  double avgtemp_f;

  Day({
    required this.maxtemp_f,
    required this.mintemp_f,
    required this.avgtemp_f,
  });

  factory Day.fromMap(Map<String, dynamic> map) {
    return Day(
      maxtemp_f: map['maxtemp_f'] as double,
      mintemp_f: map['mintemp_f'] as double,
      avgtemp_f: map['avgtemp_f'] as double,
    );
  }

  factory Day.fromJson(String source) =>
      Day.fromMap(json.decode(source) as Map<String, dynamic>);
}

@HiveType(typeId: 4)
class Hour {
  @HiveField(0)
  DateTime time;
  @HiveField(1)
  double temp_f;

  Hour({
    required this.time,
    required this.temp_f,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time': time.millisecondsSinceEpoch,
      'temp_f': temp_f,
    };
  }

  factory Hour.fromMap(Map<String, dynamic> map) {
    return Hour(
      time: DateTime.parse(map['time']),
      temp_f: map['temp_f'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Hour.fromJson(String source) =>
      Hour.fromMap(json.decode(source) as Map<String, dynamic>);
}
