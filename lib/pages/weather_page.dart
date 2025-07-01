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
  String?  _displayCity;
  double?  _accuracy;
  bool     _loading = true;

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
    'clear sky' : 'Céu Limpo',
  };

  final Map<String, String> _animationMap = {
    'clear':       'lib/assets/ensolarado.json',
    'clouds':      'lib/assets/nuvens.json',
    'thunderstorm':'lib/assets/trovao.json',
    'mist':        'lib/assets/nevoa.json',
    'drizzle':     'lib/assets/chuva_manha.json',
    'snow':        'lib/assets/neve.json',
    'fog':         'lib/assets/nevoeiro.json',
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

      final weather  = await _weatherService.getWeatherByCoords(
        pos.latitude, pos.longitude,
      );
      final cityName = await _weatherService.getCityNameFromCoords(
        pos.latitude, pos.longitude,
      );
      setState(() {
        _weather     = weather;
        _displayCity = cityName.isNotEmpty ? cityName : weather.cityName;
        _loading     = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar clima: $e')),
      );
    }
  }

  Color _bgColor(String? cond) {
    final day = isDayTime;
    if (cond == null) return day ? Colors.lightBlue.shade100 : Colors.blueGrey.shade900;
    switch (cond.toLowerCase()) {
      case 'clear':
        return day ? Colors.yellow.shade100 : Colors.indigo.shade700;
      case 'clouds':
        return day ? Colors.grey.shade200   : Colors.blueGrey.shade800;
      case 'rain':
        return day ? Colors.lightBlue.shade200 : Colors.blueGrey.shade700;
      case 'thunderstorm':
        return day ? Colors.blueGrey.shade300 : Colors.blueGrey.shade900;
      default:
        return day ? Colors.lightBlue.shade50  : Colors.grey.shade900;
    }
  }

  String _animFor(String? cond) {
    if (cond == null) return _animationMap['clear']!;
    final key = cond.toLowerCase();
    if (key == 'rain') {
      return isDayTime
        ? 'lib/assets/chuva_manha.json'
        : 'lib/assets/chuva_noite.json';
    }
    return _animationMap[key] ?? _animationMap['clear']!;
  }

  String _translate(String? cond) {
    if (cond == null) return '';
    final key = cond.toLowerCase();
    return _conditionPt[key] ??
      (key[0].toUpperCase() + key.substring(1));
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor(_weather?.condition);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: bg,
          child: Center(
            child: _loading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_displayCity != null) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: isDayTime ? Colors.black87 : Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _displayCity!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDayTime ? Colors.black87 : Colors.white,
                              shadows: const [Shadow(blurRadius: 4, color: Colors.black26)],
                            ),
                          ),
                        ],
                      ),
                      if (_accuracy != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Precisão: ${_accuracy!.toStringAsFixed(1)} m',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDayTime ? Colors.black54 : Colors.white70,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                    ],

                    SizedBox(
                      height: 200,
                      child: Lottie.asset(_animFor(_weather?.condition)),
                    ),
                    const SizedBox(height: 32),

                    Text(
                      '${_weather!.temperature.round()}°C',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: isDayTime ? Colors.black : Colors.white,
                        shadows: const [Shadow(blurRadius: 4, color: Colors.black38)],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      _translate(_weather!.condition),
                      style: TextStyle(
                        fontSize: 18,
                        color: isDayTime ? Colors.black54 : Colors.white70,
                      ),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
