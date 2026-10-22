import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static Future<Weather> fetchWeather(String cityName) async {
    final geoUrl = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=1',
    );
    final geoResponse = await http.get(geoUrl);

    if (geoResponse.statusCode != 200) {
      throw Exception('Không thể kết nối máy chủ (Mã: ${geoResponse.statusCode})');
    }

    final geoData = jsonDecode(geoResponse.body);
    if (geoData['results'] == null || (geoData['results'] as List).isEmpty) {
      throw Exception('Không tìm thấy thành phố: "$cityName"');
    }

    final firstResult = geoData['results'][0];
    final double lat = firstResult['latitude'];
    final double lon = firstResult['longitude'];
    final String resolvedName = firstResult['name'];

    final weatherUrl = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,wind_speed_10m,precipitation',
    );
    final weatherResponse = await http.get(weatherUrl);

    if (weatherResponse.statusCode != 200) {
      throw Exception('Không thể lấy dữ liệu thời tiết (Mã: ${weatherResponse.statusCode})');
    }

    final weatherData = jsonDecode(weatherResponse.body);
    return Weather.fromJson(weatherData, resolvedName);
  }
}
