import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather/weather.dart';
import 'package:weatherapp/utils/utils.dart';

class WeatherApi {
  Future<Weather> getCurrentWeather(String cityName, BuildContext context) async {
    Locale currentLocale = Localizations.localeOf(context);
    String currentLanguageCode = currentLocale.languageCode;
    WeatherFactory _wf = WeatherFactory(dotenv.get("API_KEY"), language: languageFromCode(currentLanguageCode));

    return await _wf.currentWeatherByCityName(cityName);
  }

  Future<List<Weather>> getNextFiveDaysForecast(String cityName, BuildContext context) async {
    Locale currentLocale = Localizations.localeOf(context);
    String currentLanguageCode = currentLocale.languageCode;
    WeatherFactory _wf = WeatherFactory(dotenv.get("API_KEY"), language: languageFromCode(currentLanguageCode));

    return await _wf.fiveDayForecastByCityName(cityName);
  }
}