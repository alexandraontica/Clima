import 'package:flutter/material.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/services/time.dart';
import 'package:clima/utilities/constants.dart';

class ImageWeatherCard extends StatelessWidget {
  const ImageWeatherCard({
    super.key,
    required this.dayOrNight,
    required this.weatherModel,
    required this.condition,
    required this.temperature,
    required this.feelsLikeTemp,
    required this.currentTimestamp,
    required this.timezone,
  });

  final String dayOrNight;
  final WeatherModel weatherModel;
  final int condition;
  final double temperature;
  final double feelsLikeTemp;
  final int currentTimestamp;
  final int timezone;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: dayOrNight == 'd'
              ? const AssetImage('images/day.png')
              : const AssetImage('images/night.png'),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: kBlueColor,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 10.0,
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            TimeModel().convertTimestampToLocalFormattedDateTime(
                currentTimestamp, timezone),
            textAlign: TextAlign.center,
            style: dayOrNight == 'd'
                ? kDayTempDetailsTextStyle
                : kNightTempDetailsTextStyle,
          ),
          Text(
            weatherModel.getWeatherIcon(condition, dayOrNight),
            style: kConditionTextStyle,
            textAlign: TextAlign.center,
          ),
          Text(
            " ${temperature.toStringAsFixed(0)}°",
            textAlign: TextAlign.center,
            style: kTempTextStyle,
          ),
          Text(
            weatherModel.getWeatherDescription(condition),
            textAlign: TextAlign.center,
            style: dayOrNight == 'd'
                ? kDayMessageTextStyle
                : kNightMessageTextStyle,
          ),
          const SizedBox(
            height: 40.0,
          ),
          Text(
            'Feels like ${feelsLikeTemp.toInt()}°',
            textAlign: TextAlign.center,
            style: dayOrNight == 'd'
                ? kDayTempDetailsTextStyle
                : kNightTempDetailsTextStyle,
          ),
        ],
      ),
    );
  }
}
