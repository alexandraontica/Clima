import 'package:flutter/material.dart';
import 'package:clima/components/daily_forecast_card.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key, required this.hourlyForecast});

  final dynamic hourlyForecast;

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  late List<Map> forecastWeatherInfo;

  @override
  void initState() {
    super.initState();
    updateUI(widget.hourlyForecast);
  }

  void updateUI(dynamic hourlyForecast) {
    setState(() {
      forecastWeatherInfo =
          WeatherModel().getForecastWeatherInfo(hourlyForecast);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CarouselView(
                  scrollDirection: Axis.vertical,
                  itemExtent: 125.0,
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 15.0,
                  ),
                  children: List.generate(
                    forecastWeatherInfo.length * 2 + 2,
                    (int index) {
                      if (index == 0) {
                        return Container(
                          color: kBackgroundColor,
                          child: const Align(
                            alignment: Alignment(0, 0.75),
                            child: Text(
                              'Daily Forecast',
                              style: kTitleTextStyle,
                            ),
                          ),
                        );
                      }
                      if (index == forecastWeatherInfo.length + 1) {
                        return Container(
                          color: kBackgroundColor,
                          child: const Align(
                            alignment: Alignment(0, 0.75),
                            child: Text(
                              'Predictions',
                              style: kTitleTextStyle,
                            ),
                          ),
                        );
                      }
                      if (index <= forecastWeatherInfo.length) {
                        return DailyForecastCard(
                          dayOfWeek: forecastWeatherInfo[index - 1]['day'],
                          forecastWeather: forecastWeatherInfo[index - 1]
                              ['weather'],
                        );
                      }
                      return DailyForecastCard(
                        dayOfWeek: forecastWeatherInfo[index - forecastWeatherInfo.length - 2]['day'],
                        forecastWeather: forecastWeatherInfo[index - forecastWeatherInfo.length - 2]
                            ['weather'],
                      );
                    },
                    growable: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
