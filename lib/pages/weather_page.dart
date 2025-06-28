import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/service/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('2498e270875324e27da2dda33001a50b');
  Weather? _weather;

  bool get isDayTime {
    final hour = DateTime.now().hour;
    return hour >= 6 && hour < 18;
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherByCoords();
  }

  Future<void> _fetchWeatherByCoords() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final weather = await _weatherService.getWeatherByCoords(
        pos.latitude,
        pos.longitude,
      );

      setState(() => _weather = weather);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar dados do clima: $e')),
      );
    }
  }

  Color determineBackgroundColor(String? condition, bool isDay) {
    if (condition == null) {
      return isDay ? Colors.lightBlue.shade50 : Colors.blueGrey.shade900;
    }

    switch (condition.toLowerCase()) {
      case 'clear':
        return isDay ? Colors.white : Colors.indigo.shade700;
      case 'clouds':
        return isDay ? Colors.grey.shade300 : Colors.blueGrey.shade800;
      case 'rain':
        return isDay ? Colors.blue.shade200 : Colors.blueGrey.shade700;
      case 'thunderstorm':
        return isDay ? Colors.blueGrey.shade400 : Colors.blueGrey.shade900;
      default:
        return isDay ? Colors.lightBlue.shade100 : Colors.grey.shade900;
    }
  }

  String getWeatherAnimation(String? condition) {
    if (condition == null) return 'lib/assets/nuvens.json';

    switch (condition.toLowerCase()) {
      case 'clear':
        return 'lib/assets/ensolarado.json';
      case 'clouds':
        return 'lib/assets/nuvens.json';
      case 'rain':
        return 'lib/assets/chuva_manha.json';
      case 'thunderstorm':
        return 'lib/assets/trovao.json';
      default:
        return 'lib/assets/ensolarado.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = determineBackgroundColor(_weather?.condition, isDayTime);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: bgColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _weather?.cityName ?? 'Carregando sua cidade...',
                  style: const TextStyle(fontSize: 20),
                ),

                SizedBox(
                  height: 200,
                  child: Lottie.asset(getWeatherAnimation(_weather?.condition)),
                ),
                Text(
                  _weather != null
                      ? '${_weather!.temperature.round()}°C'
                      : '—',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _weather?.condition ?? '',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
