import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/effects/animated_weather_background.dart';
import 'package:weather_app/models/user_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/pages/profile_page.dart';
import 'package:weather_app/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('2498e270875324e27da2dda33001a50b');
  Weather? _weather;
  String? _displayCity;
  double? _accuracy;
  bool _loading = true;

  final Map<String, String> _conditionPt = {
    'clear': 'Ensolarado',
    'clouds': 'Nublado',
    'rain': 'Chuva',
    'thunderstorm': 'Trovoada',
    'mist': 'Névoa',
    'drizzle': 'Chuvisco',
    'snow': 'Neve',
    'fog': 'Nevoeiro',
    'haze': 'Neblina',
    'few clouds': 'Poucas Nuvens',
    'clear sky': 'Céu Limpo',
  };

  final Map<String, String> _animationMap = {
    'clear': 'lib/assets/ensolarado.json',
    'clouds': 'lib/assets/nuvens.json',
    'thunderstorm': 'lib/assets/trovao.json',
    'mist': 'lib/assets/nevoa.json',
    'drizzle': 'lib/assets/chuva_manha.json',
    'snow': 'lib/assets/neve.json',
    'fog': 'lib/assets/nevoeiro.json',
  };

  bool get isDayTime {
    final h = DateTime.now().hour;
    return h >= 6 && h < 18;
  }

  @override
  void initState() {
    super.initState();
    _initLocationAndWeather();
  }

  Future<void> _initLocationAndWeather() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _accuracy = pos.accuracy;

      final weather = await _weatherService.getWeatherByCoords(
        pos.latitude,
        pos.longitude,
      );
      final cityName = await _weatherService.getCityNameFromCoords(
        pos.latitude,
        pos.longitude,
      );
      setState(() {
        _weather = weather;
        _displayCity = cityName.isNotEmpty ? cityName : weather.cityName;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao buscar clima: $e')));
    }
  }

  String _normalizedCondition(String? cond) {
    if (cond == null) return 'clear';
    final key = cond.toLowerCase().trim();
    if (key.contains('cloud')) return 'clouds';
    if (key.contains('rain')) return 'rain';
    if (key.contains('thunder')) return 'thunderstorm';
    if (key.contains('drizzle')) return 'drizzle';
    if (key.contains('snow')) return 'snow';
    if (key.contains('mist') || key.contains('fog') || key.contains('haze')) {
      return 'mist';
    }
    return key;
  }

  String _animFor(String? cond) {
    final key = _normalizedCondition(cond);
    if (key == 'rain') {
      return isDayTime
          ? 'lib/assets/chuva_manha.json'
          : 'lib/assets/chuva_noite.json';
    }
    return _animationMap[key] ?? _animationMap['clear']!;
  }

  String _translate(String? cond) {
    final key = _normalizedCondition(cond);
    return _conditionPt[key] ?? key[0].toUpperCase() + key.substring(1);
  }

  double _displayTemp(double tempC, TemperatureUnit unit) {
    return unit == TemperatureUnit.celsius ? tempC : tempC * 9 / 5 + 32;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel>();
    return Scaffold(
      body: Stack(
          children: [
            // Fundo com efeitos animados
            AnimatedWeatherBackground(
              condition: _normalizedCondition(_weather?.condition),
            ),

          SafeArea(
            child: Center(
              child: _loading
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botão de teste para alternar entre climas
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              final testConditions = [
                                'clear',
                                'clouds',
                                'rain',
                                'snow',
                                'mist',
                                'thunderstorm'
                              ];
                              final currentIndex = testConditions.indexOf(
                                  _normalizedCondition(_weather?.condition));
                              final next =
                                  (currentIndex + 1) % testConditions.length;
                              _weather = Weather(
                                cityName: _displayCity ?? "Cidade Teste",
                                temperature: 20,
                                condition: testConditions[next],
                                iconUrl: '', 
                              );
                            });
                          },
                          child: const Text('Alterar Clima (Teste)'),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: 200,
                          child: Lottie.asset(_animFor(_weather?.condition)),
                        ),

                        const SizedBox(height: 16),

                          Text(
                            '${_displayTemp(_weather!.temperature, user.unit).round()}°${user.unit == TemperatureUnit.celsius ? 'C' : 'F'}',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: isDayTime ? Colors.black : Colors.white,
                              shadows: const [
                              Shadow(blurRadius: 4, color: Colors.black38),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          '${_translate(_weather?.condition)} - ${isDayTime ? "Dia" : "Noite"}',
                          style: TextStyle(
                            fontSize: 20,
                            color: isDayTime ? Colors.black87 : Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        if (_accuracy != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Precisão: ${_accuracy!.toStringAsFixed(1)} m',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  isDayTime ? Colors.black54 : Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Clima',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
      ),
    );
  }
}

