import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather/weather.dart';

class WeatherApi {
  final WeatherFactory _wf = WeatherFactory(dotenv.get("API_KEY"), language: Language.PORTUGUESE_BRAZIL);

  Future<Weather> getCurrentWeather(String cityName) async {
    return await _wf.currentWeatherByCityName(cityName);
  }

  Future<List<Weather>> getNextFiveDaysForecast(String cityName) async {
    return await _wf.fiveDayForecastByCityName(cityName);
  }
}