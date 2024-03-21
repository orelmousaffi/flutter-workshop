import 'package:dio/dio.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:flutter_workshop/network/weather.config.dart';

class TripRemoteDataSource {
  Dio dio;

  TripRemoteDataSource({required this.dio});

  Future<Forecast> getWeather7days(String location, String date) async {
    final response = await dio.get(
        "https://api.weatherapi.com/v1/future.json?key=$WEATHER_API_KEY&q=$location&dt=$date");
    return Forecast.fromMap(response.data);
  }
}
