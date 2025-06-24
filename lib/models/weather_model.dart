class Weather {
  final String cityName;
  final double temperature;
  final String condition;
  final String iconUrl;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['description'],
      iconUrl: 'http://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png',
    );
  }
}