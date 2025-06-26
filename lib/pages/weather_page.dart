import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/service/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('2498e270875324e27da2dda33001a50b');
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() => _weather = weather);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar dados do clima: $e')),
      );
    }
  }

  String getWeatherAnimation(String? condition) {
    if (condition == null) return 'lib/assets/ensolarado.json';

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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nome da cidade
              Text(
                _weather?.cityName ?? 'Carregando sua cidade...',
                style: TextStyle(fontSize: 20),
              ),

              // Animação com altura fixa para evitar overflow
              SizedBox(
                height: 200,
                child: Lottie.asset(
                  getWeatherAnimation(_weather?.condition),
                ),
              ),

              // Temperatura (protected null-safety)
              Text(
                _weather != null
                  ? '${_weather!.temperature.round()}°C'
                  : '—',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),

              // Condição principal
              Text(
                _weather?.condition ?? '',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
