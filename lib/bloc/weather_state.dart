import 'package:weather_app/model/weather_model.dart';

sealed class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherDataLoading extends WeatherState {}

class WeatherDataSuccess extends WeatherState {
  WeathterModel weatherModel;
  WeatherDataSuccess(this.weatherModel);
}

class WeatherDataError extends WeatherState {
  String error;
  WeatherDataError(this.error);
}
