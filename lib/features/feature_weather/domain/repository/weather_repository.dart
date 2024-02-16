import 'package:clean_architecture/core/params/forecast_params.dart';
import 'package:clean_architecture/core/resources/data_state.dart';
import 'package:clean_architecture/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:clean_architecture/features/feature_weather/domain/entities/forecast_days_entity.dart';

import '../../data/models/suggest_city_model.dart';

abstract class WeatherRepository{

  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);

  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params);

  Future<List<Data>> fetchSuggestData(cityName);

}