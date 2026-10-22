class Weather {
  final String cityName;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final double precipitation;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    final current = json['current'];
    return Weather(
      cityName: cityName,
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      precipitation: (current['precipitation'] as num).toDouble(),
    );
  }

  String get umbrellaAdvice {
    if (precipitation > 0) {
      return '🌧️ Đang có mưa (${precipitation}mm). Bạn nên mang theo ô!';
    }
    return '☀️ Trời khô ráo, không cần mang ô.';
  }

  String get outfitAdvice {
    if (temperature < 18) {
      return '🧥 Trời khá lạnh (${temperature.toStringAsFixed(1)}°C). Bạn nên mặc áo ấm.';
    } else if (temperature > 32) {
      return '👕 Trời nóng (${temperature.toStringAsFixed(1)}°C). Nên mặc đồ thoáng mát và uống nhiều nước.';
    }
    return '✨ Thời tiết mát mẻ dễ chịu (${temperature.toStringAsFixed(1)}°C). Mặc trang phục thường ngày.';
  }
}
