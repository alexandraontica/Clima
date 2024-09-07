import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/services/location.dart';
import 'package:clima/components/navbar.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    Location location = Location();
    await location.getCurrentLocation(context);

    var weatherData = await WeatherModel().getLocationWeather(location);
    var hourlyForecast = await WeatherModel().getHourlyLocationForecast(location);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Navbar(
          locationWeather: weatherData,
          hourlyForecast: hourlyForecast,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Color(0xffffffff),
          size: 100,
        ),
      ),
    );
  }
}
