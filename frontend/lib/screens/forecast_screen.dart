import 'package:flutter/material.dart';
import 'package:clima/components/daily_forecast_card.dart';
import 'package:clima/components/hourly_forecast_card.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({
    super.key,
    required this.hourlyForecast,
    required this.predictions,
  });

  final dynamic hourlyForecast;
  final dynamic predictions;

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
              const SizedBox(
                height: 25.0,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 160.0),
                child: CarouselView(
                  itemExtent: 200,
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 8.0,
                  ),
                  children: List.generate(
                    8, // the api returns the forecast with a 3-hour step, so in 24 hours there are 8 elements
                    (int index) => HourlyForecastCard(
                      forecast: widget.hourlyForecast["list"][index],
                      timezone: widget.hourlyForecast["city"]["timezone"],
                      index: index,
                      predicttedApparentTemp: widget.predictions["predictions"][index],
                    ),
                    growable: false,
                  ),
                ),
              ),
              Text(
                "Ⓘ The apparent temperature was predicted using AI"
              ),
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
                    forecastWeatherInfo.length + 1,
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
                      return DailyForecastCard(
                        dayOfWeek: forecastWeatherInfo[index - 1]['day'],
                        forecastWeather: forecastWeatherInfo[index - 1]
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
