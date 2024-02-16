import 'package:clean_architecture/core/params/forecast_params.dart';
import 'package:clean_architecture/core/resources/data_state.dart';
import 'package:clean_architecture/core/use_case/use_case.dart';
import 'package:clean_architecture/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:clean_architecture/features/feature_weather/domain/repository/weather_repository.dart';

class GetForecastWeatherUseCase implements UseCase<DataState<ForecastDaysEntity>,ForecastParams>{
  final WeatherRepository _weatherRepository;


  GetForecastWeatherUseCase(this._weatherRepository);

  @override
  Future<DataState<ForecastDaysEntity>> call(ForecastParams params) {
    return _weatherRepository.fetchForecastWeatherData(params);
  }


}