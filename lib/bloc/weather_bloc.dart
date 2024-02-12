import 'package:bloc/bloc.dart';
import 'package:weather_app/bloc/weather_event.dart';
import 'package:weather_app/bloc/weather_state.dart';

import '../data/data_repository/weather_data_repository.dart';

class WeatherBloc extends Bloc<WeatherEvents, WeatherState> {
  WeatherDataRepository weatherDataRepository;
  WeatherBloc(this.weatherDataRepository) : super(WeatherInitial()) {
    on<WeatherDataFetchEvents>(_fetchDataEvent);
  }
  void _fetchDataEvent(
      WeatherDataFetchEvents events, Emitter<WeatherState> emit) async {
    emit(WeatherDataLoading());

    try {
      final data =
          await weatherDataRepository.getCurrentWeather(events.countryName);
      emit(WeatherDataSuccess(data));
    } catch (e) {
      emit(WeatherDataError(e.toString()));
    }
  }
}
