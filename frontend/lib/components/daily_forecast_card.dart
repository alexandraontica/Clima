import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';

class DailyForecastCard extends StatelessWidget {
  const DailyForecastCard({
    super.key,
    required this.dayOfWeek,
    required this.forecastWeather,
  });

  final String dayOfWeek;
  final Map forecastWeather;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${dayOfWeek.substring(0, 3)}.",
            style: kHourTextStyle,
          ),
          Text(
            forecastWeather['condition'],
            style: kTempTextStyle,
          ),
          Text(
            '${forecastWeather['temp_max'].toInt()}°/${forecastWeather['temp_min'].toInt()}°',
            style: kForecastTempTextStyle,
          ),
        ],
      ),
    );
  }
}
