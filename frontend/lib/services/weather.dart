import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/services/time.dart';

const apiKey = 'bbae28eed0c7ad192631395d7af812e5';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5';
const predictionsURL = 'http://192.168.1.198:5000/predict';

class WeatherModel {
  Future getLocationWeather(Location location) async {
    String url =
        '$openWeatherMapURL/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric';
    Networking networking = Networking(url);

    var weatherData = await networking.getData();

    return weatherData;
  }

  Future getCityWeather(String cityName) async {
    cityName = cityName.trimRight();
    String encodedCityName = Uri.encodeComponent(cityName);
    String url =
        '$openWeatherMapURL/weather?q=$encodedCityName&appid=$apiKey&units=metric';
    Networking networking = Networking(url);

    var weatherData = await networking.getData();

    return weatherData;
  }

  Future getHourlyLocationForecast(Location location) async {
    String url =
        '$openWeatherMapURL/forecast?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric';
    Networking networking = Networking(url);

    var weatherData = await networking.getData();

    return weatherData;
  }

  Future getHourlyCityForecast(String cityName) async {
    cityName = cityName.trimRight();
    String encodedCityName = Uri.encodeComponent(cityName);
    String url =
        '$openWeatherMapURL/forecast?q=$encodedCityName&appid=$apiKey&units=metric';
    Networking networking = Networking(url);

    var weatherData = await networking.getData();

    return weatherData;
  }

  String getWeatherIcon(int condition, String dayOrNight) {
    if (condition < 300) {
      if (condition >= 230 && condition <= 232) {
        return '⛈️';
      }
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '🌧️';
    } else if (condition < 700) {
      return '🌨️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      if (dayOrNight == 'n') {
        return '🌙';
      }
      return '☀️';
    } else if (condition == 801) {
      if (dayOrNight == 'n') {
        return '☁️';
      }
      return '🌤️';
    } else if (condition == 802) {
      if (dayOrNight == 'n') {
        return '☁️';
      }
      return '⛅';
    } else if (condition == 803) {
      if (dayOrNight == 'n') {
        return '☁️';
      }
      return '🌥️';
    } else if (condition == 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getWeatherDescription(int condition) {
    return weatherConditions[condition] ?? 'unknown weather condition';
  }

  List<String> getWeekDaysWithCompleteWeather(dynamic hourlyForecast) {
    int timezone;
    List<dynamic> forecastList;

    try {
      timezone = hourlyForecast['city']['timezone'];
      forecastList = hourlyForecast['list'];
    } catch (e) {
      timezone = 0;
      forecastList = [
        {
          'dt': 10,
        }
      ];
    }

    Map<String, int> occurrences = {};
    List<String> completeDays = [];

    for (var forecast in forecastList) {
      String dayOfWeek = TimeModel().convertTimestampToLocalDayOfWeek(
        forecast['dt'],
        timezone,
      );

      occurrences[dayOfWeek] = (occurrences[dayOfWeek] ?? 0) + 1;
    }

    for (var entry in occurrences.entries) {
      if (entry.value == 8) {
        // the api returns the forecast with a 3-hour step
        // so a day (24 hours) is complete if it has 8 forecast elements
        completeDays.add(entry.key);
      }
    }

    return completeDays;
  }

  int getForecastCondition(List<int> conditions) {
    Map<int, int> occurrences = {};

    for (int condition in conditions) {
      occurrences[condition] = (occurrences[condition] ?? 0) + 1;
    }

    int maxOccurrences = 0;
    int mostFrequentCondition = 900;

    for (var entry in occurrences.entries) {
      if (entry.value > maxOccurrences) {
        maxOccurrences = entry.value;
        mostFrequentCondition = entry.key;
      }
    }

    return mostFrequentCondition;
  }

  List<Map> getForecastWeatherInfo(dynamic hourlyForecast) {
    List<String> completeDays = getWeekDaysWithCompleteWeather(hourlyForecast);
    Map<String, Map> forecastWeatherInfo = {};
    Map<String, List<int>> forecastConditions = {};

    for (String day in completeDays) {
      forecastWeatherInfo[day] = {
        'temp_max': -100,
        'temp_min': 100,
        'condition': '',
      };
      forecastConditions[day] = [];
    }

    int timezone;
    List<dynamic> forecastList;

    try {
      timezone = hourlyForecast['city']['timezone'];
      forecastList = hourlyForecast['list'];
    } catch (e) {
      timezone = 0;
      forecastList = [
        {
          'dt': 0,
          'main': {
            'temp_max': 15.0,
            'temp_min': 15.0,
          },
          'weather': [
            {
              'id': 900,
            }
          ],
        }
      ];
    }

    for (var forecast in forecastList) {
      String day = TimeModel().convertTimestampToLocalDayOfWeek(
        forecast['dt'] ?? 0,
        timezone,
      );

      if (completeDays.contains(day)) {
        if (forecast['main']['temp_max'] >
            forecastWeatherInfo[day]?['temp_max']) {
          forecastWeatherInfo[day]?['temp_max'] = forecast['main']['temp_max'];
        }

        if (forecast['main']['temp_min'] <
            forecastWeatherInfo[day]?['temp_min']) {
          forecastWeatherInfo[day]?['temp_min'] = forecast['main']['temp_min'];
        }

        forecastConditions[day]?.add(forecast['weather'][0]['id']);
      }
    }

    // the elements returned must be in form of list to iterate through them using indexes (see forecast_screen.dart)
    List<Map> forecastWeatherInfoList = [];

    for (String day in completeDays) {
      int condition = getForecastCondition(forecastConditions[day]!);
      String conditionIcon = getWeatherIcon(condition, 'd');
      forecastWeatherInfo[day]?['condition'] = conditionIcon;

      forecastWeatherInfoList.add({
        'day': day,
        'weather': forecastWeatherInfo[day],
      });
    }

    return forecastWeatherInfoList;
  }

  Future getApparentTempPredictions(dynamic hourlyForecast) async {
    Networking networking = Networking(predictionsURL);

    var predictions = await networking.postRequest(hourlyForecast);

    return predictions;
  }

  final Map<int, String> weatherConditions = {
    // Thunderstorm
    200: 'thunderstorm with light rain',
    201: 'thunderstorm with rain',
    202: 'thunderstorm with heavy rain',
    210: 'light thunderstorm',
    211: 'thunderstorm',
    212: 'heavy thunderstorm',
    221: 'ragged thunderstorm',
    230: 'thunderstorm with light drizzle',
    231: 'thunderstorm with drizzle',
    232: 'thunderstorm with heavy drizzle',
    // Drizzle
    300: 'light intensity drizzle',
    301: 'drizzle',
    302: 'heavy intensity drizzle',
    310: 'light intensity drizzle rain',
    311: 'drizzle rain',
    312: 'heavy intensity drizzle rain',
    313: 'shower rain and drizzle',
    314: 'heavy shower rain and drizzle',
    321: 'shower drizzle',
    // Rain
    500: 'light rain',
    501: 'moderate rain',
    502: 'heavy intensity rain',
    503: 'very heavy rain',
    504: 'extreme rain',
    511: 'freezing rain',
    520: 'light intensity shower rain',
    521: 'shower rain',
    522: 'heavy intensity shower rain',
    531: 'ragged shower rain',
    // Snow
    600: 'light snow',
    601: 'snow',
    602: 'heavy snow',
    611: 'sleet',
    612: 'light shower sleet',
    613: 'shower sleet',
    615: 'light rain and snow',
    616: 'rain and snow',
    620: 'light shower snow',
    621: 'shower snow',
    622: 'heavy shower snow',
    // Atmosphere
    701: 'mist',
    711: 'smoke',
    721: 'haze',
    731: 'sand/dust whirls',
    741: 'fog',
    751: 'sand',
    761: 'dust',
    762: 'volcanic ash',
    771: 'squalls',
    781: 'tornado',
    // Clear
    800: 'clear sky',
    // Clouds
    801: 'few clouds',
    802: 'scattered clouds',
    803: 'broken clouds',
    804: 'overcast clouds',
  };
}
