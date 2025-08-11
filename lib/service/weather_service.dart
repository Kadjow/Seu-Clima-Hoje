import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const String _geoUrl  = 'https://api.openweathermap.org/geo/1.0/reverse';
  static const String _directGeoUrl = 'https://api.openweathermap.org/geo/1.0/direct';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeatherByCoords(double lat, double lon) async {
    final uri = Uri.parse('$_baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    final response = await http.get(uri);
    debugPrint('GET $uri → ${response.statusCode}');
    debugPrint('BODY: ${response.body}');
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    }
    throw Exception('Erro ao carregar clima ($lat, $lon): ${response.statusCode}');
  }

  Future<Weather> getWeatherByCity(String city) async {
    final uri =
        Uri.parse('$_baseUrl?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(uri);
    debugPrint('GET $uri → ${response.statusCode}');
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    }
    throw Exception('Erro ao carregar clima ($city): ${response.statusCode}');
  }

  Future<String> getCityNameFromCoords(double lat, double lon) async {
    final uri = Uri.parse('$_geoUrl?lat=$lat&lon=$lon&limit=1&appid=$apiKey');
    final response = await http.get(uri);
    debugPrint('GET $uri → ${response.statusCode}');
    debugPrint('GEO BODY: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      if (data.isNotEmpty && (data[0]['local_names']?['pt'] ?? data[0]['name']) != null) {
        return (data[0]['local_names']?['pt'] as String?) ??
               (data[0]['name'] as String);
      }
      return '';
    }
    throw Exception('Erro no reverse geocode ($lat, $lon): ${response.statusCode}');
  }

  Future<List<String>> searchCities(String query) async {
    final uri = Uri.parse(
        '$_directGeoUrl?q=$query&limit=5&appid=$apiKey&lang=pt');
    final response = await http.get(uri);
    debugPrint('GET $uri → ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map<String>((e) {
        final local = (e['local_names']?['pt'] as String?) ?? e['name'];
        return local as String;
      }).toList();
    }
    throw Exception('Erro ao buscar cidades: ${response.statusCode}');
  }
}
