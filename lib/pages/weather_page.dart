import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/service/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherPage extends StatefulWidget { 
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService('2498e270875324e27da2dda33001a50b');
  Weather? _weather;

_fecthWeather() async {
  String cityName = await _weatherService.getCurrentCity();

  try {
    final Weather = await _weatherService.getWeather(cityName);
    setState(() {
      _weather = Weather;
    });
  }
  catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching weather data: $e')),
    );
  }
}

  @override
  void initState() {
    super.initState();
    _fecthWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? 'Carregando sua Cidade...',),
            
            Lottie.asset('lib/assets/ensolarado.json'),

            Text(_weather?.temperature != null
                ? '${_weather!.temperature}°C'
                : 'Carregando temperatura...'),
          ],
        )
      ),
    );
  }
}