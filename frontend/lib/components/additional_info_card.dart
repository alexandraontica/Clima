import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/time.dart';

class AdditionalInfoCard extends StatelessWidget {
  const AdditionalInfoCard({
    super.key,
    required this.humidity,
    required this.windSpeed,
    required this.sunriseTimestamp,
    required this.sunsetTimestamp,
    required this.timezone,
  });

  final int humidity;
  final double windSpeed;
  final int sunriseTimestamp;
  final int sunsetTimestamp;
  final int timezone;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Text(
                'Humidity',
                style: kLabelWeatherInfoTextStyle,
              ),
              Text(
                '${humidity.toString()}%',
                style: kAdditionalWeatherInfoTextStyle,
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Wind Speed',
                style: kLabelWeatherInfoTextStyle,
              ),
              Text(
                '${windSpeed.toInt()} km/h',
                style: kAdditionalWeatherInfoTextStyle,
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Sunrise',
                style: kLabelWeatherInfoTextStyle,
              ),
              Text(
                TimeModel().convertTimestampToLocalTime(sunriseTimestamp, timezone),
                style: kAdditionalWeatherInfoTextStyle,
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Sunset',
                style: kLabelWeatherInfoTextStyle,
              ),
              Text(
                TimeModel().convertTimestampToLocalTime(sunsetTimestamp, timezone),
                style: kAdditionalWeatherInfoTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
