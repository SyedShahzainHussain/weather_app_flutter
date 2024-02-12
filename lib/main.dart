import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/data/data_provider/weather_data_provider.dart';
import 'package:weather_app/data/data_repository/weather_data_repository.dart';
import 'package:weather_app/presentation/screen/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool serviceEnabled = false;
  void getCurrentLocation() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        setState(() {
          serviceEnabled = true;
        });
      } else {
        Permission.location.request().then((value) {
          setState(() {
            serviceEnabled = (value == PermissionStatus.granted);
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WeatherBloc(WeatherDataRepository(WeatherDataProvider())),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home: const WeatherScreen(),
      ),
    );
  }
}
