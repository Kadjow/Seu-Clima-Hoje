import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/user_model.dart';
import 'package:weather_app/pages/weather_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  user.avatarUrl.isNotEmpty ? NetworkImage(user.avatarUrl) : null,
              child: user.avatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Modo escuro'),
              value: user.darkMode,
              onChanged: (_) => user.toggleTheme(),
            ),
            SwitchListTile(
              title: const Text('Usar Fahrenheit'),
              value: user.unit == TemperatureUnit.fahrenheit,
              onChanged: (_) => user.toggleUnit(),
            ),
            const SizedBox(height: 24),
            if (!user.isLoggedIn) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => user.login('Usuário'),
                    child: const Text('Login'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => user.login('Novo usuário'),
                    child: const Text('Registrar'),
                  ),
                ],
              ),
            ] else ...[
              ElevatedButton(
                onPressed: user.logout,
                child: const Text('Sair'),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WeatherPage()),
            );
          }
        },
      ),
    );
  }
}
