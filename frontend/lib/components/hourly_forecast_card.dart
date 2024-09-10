import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/services/time.dart';

class HourlyForecastCard extends StatelessWidget {
  const HourlyForecastCard({
    super.key,
    required this.forecast,
    required this.timezone,
    required this.index,
    required this.predicttedApparentTemp,
  });

  final dynamic forecast;
  final int timezone;
  final int index;
  final double predicttedApparentTemp;

  @override
  Widget build(BuildContext context) {
    String dayOrNight = forecast['weather'][0]['icon'];
    dayOrNight = dayOrNight.substring(dayOrNight.length - 1);
    int condition = forecast['weather'][0]['id'];

    return Container(
      color: index == 0 ? kBlueColor : kCardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                WeatherModel().getWeatherIcon(condition, dayOrNight),
                style: kTempTextStyle,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    TimeModel()
                        .convertTimestampToLocalTime(forecast['dt'], timezone),
                    style: kHourTextStyle,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${forecast['main']['temp'].toInt()}°',
                    style: kHourlyTempTextStyle,
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: predicttedApparentTemp == 100 ? EdgeInsets.only(top: 0.0) : EdgeInsets.only(top: 8.0),
            child: Text(
              predicttedApparentTemp == 100
                  ? "No prediction available"
                  : "Feels like ${predicttedApparentTemp.toInt()}°",
              style: kHourlyAppTempTextStyle,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
