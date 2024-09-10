import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/time.dart';
import 'package:clima/components/image_weather_card.dart';
import 'package:clima/components/additional_info_card.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    super.key,
    required this.locationWeather,
    required this.onLocationChange,
  });

  final dynamic locationWeather;
  final Function(dynamic, dynamic, dynamic) onLocationChange;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  late double temperature;
  late int condition;
  late String cityName;
  late String dayOrNight;
  late double feelsLikeTemp;
  late int currentTimestamp;
  late int humidity;
  late double windSpeed;
  late int sunriseTimestamp;
  late int sunsetTimestamp;
  late int timezone;
  late List hourlyForecastList;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      try {
        temperature = weatherData['main']['temp'];
        condition = weatherData['weather'][0]['id'];
        cityName = weatherData['name'];
        dayOrNight = weatherData['weather'][0]['icon'];
        dayOrNight = dayOrNight.substring(dayOrNight.length - 1);
        feelsLikeTemp = weatherData['main']['feels_like'];
        currentTimestamp = weatherData['dt'];
        humidity = weatherData['main']['humidity'];
        windSpeed = weatherData['wind']['speed'] * 3.6; // transform m/s to km/h
        sunriseTimestamp = weatherData['sys']['sunrise'];
        sunsetTimestamp = weatherData['sys']['sunset'];
        timezone = weatherData['timezone'];

        // the font doesn't support the letter ț
        cityName = cityName.replaceAll('ț', 't');
      } catch (e) {
        condition = 900;
        temperature = 15;
        cityName = 'Invalid city name';
        dayOrNight = 'd';
        feelsLikeTemp = 15;
        currentTimestamp = 0;
        humidity = 0;
        windSpeed = 0;
        sunriseTimestamp = 1725514838;
        sunsetTimestamp = 1725565244;
        timezone = 0;

        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23.0),
                      child: Text(
                        cityName,
                        style: kCityTextStyle,
                      ),
                    ),
                    FilledButton(
                      style: kIconButtonStyle,
                      onPressed: () async {
                        Location location = Location();
                        await location.getCurrentLocation(context);

                        var weatherData =
                            await weatherModel.getLocationWeather(location);
                        var hourlyForecast = await WeatherModel()
                            .getHourlyLocationForecast(location);
                        var predictions = await weatherModel
                            .getApparentTempPredictions(hourlyForecast);

                        updateUI(weatherData);
                        widget.onLocationChange(
                            weatherData, hourlyForecast, predictions);
                      },
                      child: const Icon(
                        Icons.location_on,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              ),
              ImageWeatherCard(
                dayOrNight: dayOrNight,
                weatherModel: weatherModel,
                condition: condition,
                temperature: temperature,
                feelsLikeTemp: feelsLikeTemp,
                currentTimestamp: currentTimestamp,
                timezone: timezone,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AdditionalInfoCard(
                        label: 'Humidity',
                        info: '${humidity.toString()}%',
                        icon: Icons.water_drop_outlined,
                        margins: EdgeInsets.only(
                          left: 18.0,
                          top: 10.0,
                          right: 4.0,
                          bottom: 4.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: AdditionalInfoCard(
                        label: 'Wind Speed',
                        info: '${windSpeed.toInt()} km/h',
                        icon: Icons.wind_power_outlined,
                        margins: EdgeInsets.only(
                          right: 18.0,
                          top: 10.0,
                          left: 4.0,
                          bottom: 4.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AdditionalInfoCard(
                        label: 'Sunrise',
                        info: TimeModel().convertTimestampToLocalTime(
                            sunriseTimestamp, timezone),
                        icon: Icons.wb_twilight_sharp,
                        margins: EdgeInsets.only(
                          left: 18.0,
                          bottom: 10.0,
                          right: 4.0,
                          top: 4.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: AdditionalInfoCard(
                        label: 'Sunset',
                        info: TimeModel().convertTimestampToLocalTime(
                            sunsetTimestamp, timezone),
                        icon: Icons.wb_twilight_rounded,
                        margins: EdgeInsets.only(
                          right: 18.0,
                          bottom: 10.0,
                          left: 4.0,
                          top: 4.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
