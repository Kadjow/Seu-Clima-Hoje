import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weather_app/service/weather_service.dart';

class CitySearchState {
  final bool loading;
  final List<String> results;
  final String? error;
  CitySearchState({required this.loading, required this.results, this.error});
}

CitySearchState useCitySearch(WeatherService service, String query) {
  final results = useState<List<String>>([]);
  final loading = useState(false);
  final error = useState<String?>(null);

  useEffect(() {
    if (query.isEmpty) {
      results.value = [];
      return null;
    }
    loading.value = true;
    error.value = null;
    Future(() async {
      try {
        results.value = await service.searchCities(query);
      } catch (e) {
        error.value = e.toString();
      } finally {
        loading.value = false;
      }
    });
    return null;
  }, [query]);

  return CitySearchState(
    loading: loading.value,
    results: results.value,
    error: error.value,
  );
}
