import 'package:clean_architecture/core/use_case/use_case.dart';
import 'package:clean_architecture/features/feature_weather/data/models/suggest_city_model.dart';

import '../repository/weather_repository.dart';

class GetSuggestionCityUseCase implements UseCase <List<Data>, String>{
  final WeatherRepository weatherRepository;

  GetSuggestionCityUseCase(this.weatherRepository);

  @override
  Future<List<Data>> call(String param) {
    return weatherRepository.fetchSuggestData(param);
  }


}