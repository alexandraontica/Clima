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
  });

  final dynamic locationWeather;
  final dynamic hourlyForecast;

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
        hourlyForecast: widget.hourlyForecast,
        onLocationChange: locationChange,
      ),
      ForecastScreen(
        hourlyForecast: widget.hourlyForecast,
      ),
      CityScreen(onCityChange: cityChange),
    ];
  }

  void locationChange(dynamic locationWeather, dynamic hourlyForecast) {
    setState(() {
      _widgetOptions[0] = LocationScreen(
          locationWeather: locationWeather,
          hourlyForecast: hourlyForecast,
          onLocationChange: locationChange,
        );
      _widgetOptions[1] = ForecastScreen(
        hourlyForecast: hourlyForecast,
      );
    });
  }

  void cityChange(String city) async {
    if (city != '') {
      var locationWeather = await WeatherModel().getCityWeather(city);
      var hourlyForecast = await WeatherModel().getHourlyCityForecast(city);
      locationChange(locationWeather, hourlyForecast);

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
