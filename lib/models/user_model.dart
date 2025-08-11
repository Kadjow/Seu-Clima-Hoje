import 'package:flutter/material.dart';

enum TemperatureUnit { celsius, fahrenheit }

class UserModel extends ChangeNotifier {
  String name;
  String avatarUrl;
  bool isLoggedIn;
  TemperatureUnit unit;
  bool darkMode;

  UserModel({
    this.name = 'Convidado',
    this.avatarUrl = '',
    this.isLoggedIn = false,
    this.unit = TemperatureUnit.celsius,
    this.darkMode = false,
  });

  void toggleUnit() {
    unit = unit == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
    notifyListeners();
  }

  void toggleTheme() {
    darkMode = !darkMode;
    notifyListeners();
  }

  void login(String newName) {
    name = newName;
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    name = 'Convidado';
    isLoggedIn = false;
    notifyListeners();
  }
}
