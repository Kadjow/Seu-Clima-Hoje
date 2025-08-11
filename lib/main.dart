import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/user_model.dart';
import 'package:weather_app/splash/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      final user = context.watch<UserModel>();
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: user.darkMode ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(),
      );
    }
}
  