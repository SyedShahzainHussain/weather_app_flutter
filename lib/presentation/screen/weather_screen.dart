import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart'
    show Placemark, placemarkFromCoordinates;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/bloc/weather_event.dart';
import 'package:weather_app/bloc/weather_state.dart';
import 'package:weather_app/presentation/widget/additional_forecast_item.dart';

import '../widget/hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>>? weather;
  String cityName = "Canada";

  getLocation() async {
    Location location = Location();
    final userlocation = await location.getLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        userlocation.latitude!, userlocation.longitude!);

    setState(() {
      cityName = placemarks[0].locality.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    context.read<WeatherBloc>().add(WeatherDataFetchEvents(cityName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<WeatherBloc>().add(WeatherDataFetchEvents(cityName));
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
        if (state is WeatherDataLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is WeatherDataSuccess) {
          final WeatherDataSuccess data = state;

          final currentTemp = data.weatherModel.list![0].temp;
          final currentSky = data.weatherModel.list![0].weather![0].main;
          final currentPressure = data.weatherModel.list![0].pressure;
          final currentWindSpeed =
              data.weatherModel.list![0].wind!.speed.toString();
          final currentHumidity = data.weatherModel.list![0].humidity;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Colors.lightBlueAccent,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp T',
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                color: Colors.white,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentSky.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data.weatherModel.list![index + 1];
                      final hourlySky = data
                          .weatherModel.list![index + 1].weather![0].main
                          .toString();
                      final hourlyTemp = hourlyForecast.temp.toString();
                      final time =
                          DateTime.parse(hourlyForecast.dt_txt.toString());
                      return HourlyForecastItem(
                        time: DateFormat.jm().format(time),
                        temperature: hourlyTemp,
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        if (state is WeatherDataError) {
          return Center(
            child: Text(state.error),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
