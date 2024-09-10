import 'package:flutter/material.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:clima/screens/forecast_screen.dart';
import 'package:clima/services/weather.dart';

class Navbar extends StatefulWidget {
  const Navbar({
    super.key,
    required this.locationWeather,
    required this.hourlyForecast,
    required this.predictions,
  });

  final dynamic locationWeather;
  final dynamic hourlyForecast;
  final dynamic predictions;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int currentPageIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      LocationScreen(
        locationWeather: widget.locationWeather,
        onLocationChange: locationChange,
      ),
      ForecastScreen(
        hourlyForecast: widget.hourlyForecast,
        predictions: widget.predictions,
      ),
      CityScreen(onCityChange: cityChange),
    ];
  }

  void locationChange(dynamic locationWeather, dynamic hourlyForecast, dynamic predictions) {
    setState(() {
      _widgetOptions[0] = LocationScreen(
          locationWeather: locationWeather,
          onLocationChange: locationChange,
        );
      _widgetOptions[1] = ForecastScreen(
        hourlyForecast: hourlyForecast,
        predictions: predictions,
      );
    });
  }

  void cityChange(String city) async {
    if (city != '') {
      var locationWeather = await WeatherModel().getCityWeather(city);
      var hourlyForecast = await WeatherModel().getHourlyCityForecast(city);
      var predictions = await WeatherModel().getApparentTempPredictions(hourlyForecast);
      locationChange(locationWeather, hourlyForecast, predictions);

      currentPageIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(currentPageIndex),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Color(0xffffffff),
            ),
            label: 'Current weather',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.calendar_month,
              color: Color(0xffffffff),
            ),
            label: 'Forecast and Predictions',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.search,
              color: Color(0xffffffff),
            ),
            label: 'Search city',
          ),
        ],
      ),
    );
  }
}
