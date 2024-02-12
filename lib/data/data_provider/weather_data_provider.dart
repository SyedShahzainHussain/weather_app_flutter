import 'package:http/http.dart';
import 'package:weather_app/secrets.dart';

class WeatherDataProvider {
  Future<String> getCurrentWeather(String cityName) async {
    try {
      final res = await get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApi',
        ),
      );

      final data = res.body;

      return data;
    } catch (e) {
      throw e.toString();
    }
  }
}
