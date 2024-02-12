import 'dart:convert';

import 'package:weather_app/data/data_provider/weather_data_provider.dart';
import 'package:weather_app/model/weather_model.dart';

class WeatherDataRepository {
  final WeatherDataProvider weatherDataProvider;
  WeatherDataRepository(this.weatherDataProvider);

  Future<WeathterModel> getCurrentWeather(String cityName) async {
    try {
      final data = await weatherDataProvider.getCurrentWeather(cityName);
      final weatherData = jsonDecode(data);

      if (weatherData['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return WeathterModel.fromJson(weatherData);
    } catch (e) {
      throw e.toString();
    }
  }
}
