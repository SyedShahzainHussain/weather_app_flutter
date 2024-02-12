sealed class WeatherEvents {}

class WeatherDataFetchEvents extends WeatherEvents {
  String countryName;
  WeatherDataFetchEvents(this.countryName);
}
