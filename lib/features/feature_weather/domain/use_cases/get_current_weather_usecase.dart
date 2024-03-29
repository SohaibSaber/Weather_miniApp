import 'package:clean_architecture/core/use_case/use_case.dart';
import 'package:clean_architecture/features/feature_weather/domain/repository/weather_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../entities/current_city_entity.dart';

class GetCurrentWeatherUseCase extends UseCase<DataState<CurrentCityEntity>, String>{

  final WeatherRepository weatherRepository;

  GetCurrentWeatherUseCase(this.weatherRepository);

  @override
  Future<DataState<CurrentCityEntity>> call(String param) {
    return weatherRepository.fetchCurrentWeatherData(param);

  }

//   Future<DataState<CurrentCityEntity>>  call (String cityName){
//
//   }
}