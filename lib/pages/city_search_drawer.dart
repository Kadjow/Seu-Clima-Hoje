import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weather_app/hooks/use_city_search.dart';
import 'package:weather_app/service/weather_service.dart';

class CitySearchDrawer extends HookWidget {
  final WeatherService service;
  final ValueChanged<String> onCitySelected;

  const CitySearchDrawer({
    super.key,
    required this.service,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final query = useState('');
    final state = useCitySearch(service, query.value);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Buscar cidade'),
                onChanged: (v) => query.value = v,
              ),
            ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(state.error!, style: const TextStyle(color: Colors.red)),
              ),
            if (state.loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (state.results.isEmpty && query.value.isNotEmpty)
              const Expanded(child: Center(child: Text('Nenhuma cidade encontrada')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (context, index) {
                    final city = state.results[index];
                    return ListTile(
                      title: Text(city),
                      onTap: () {
                        onCitySelected(city);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
