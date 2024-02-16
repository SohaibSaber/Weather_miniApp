import 'package:clean_architecture/core/params/forecast_params.dart';
import 'package:clean_architecture/core/resources/data_state.dart';
import 'package:clean_architecture/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:clean_architecture/features/feature_weather/data/models/current_city_model.dart';
import 'package:clean_architecture/features/feature_weather/data/models/forecast_model.dart';
import 'package:clean_architecture/features/feature_weather/data/models/suggest_city_model.dart';
import 'package:clean_architecture/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:clean_architecture/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:clean_architecture/features/feature_weather/domain/entities/suggest_city_entity.dart';
import 'package:clean_architecture/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class WeatherRepositoryImpl extends WeatherRepository {
  ApiProvider apiProvider;


  WeatherRepositoryImpl(this.apiProvider);

  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(
      String cityName) async {

    try {
      Response response = await apiProvider.callCurrentWeather(cityName);
      if (response.statusCode == 200) {
        CurrentCityEntity currentCityEntity =
            CurrentCityModel.fromJson(response.data);
        return DataSuccess(currentCityEntity);
      }
      else {
        return const DataFailed("something went wrong try again");
      }
    } catch (e) {
      print(e);
      return const DataFailed("check your connection");
    }

}

  @override
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params) async {

    try {
      Response response = await apiProvider.sendRequest7DaysForeCast(params);
      if (response.statusCode == 200) {
        ForecastDaysEntity forecastDaysEntity =
        ForecastModel.fromJson(response.data);
        return DataSuccess(forecastDaysEntity);
      }
      else {
        return const DataFailed("something went wrong try again");
      }
    } catch (e) {
      print(e);
      return const DataFailed("check your connection");
    }
  }

  @override
  Future<List<Data>> fetchSuggestData(cityName) async {
    try {
      Response response = await apiProvider.sendRequestCitySuggestion(cityName);
      if (response.statusCode == 200) {
        SuggestCityEntity suggestCityEntity = SuggestCityModel.fromJson(response.data);
        return suggestCityEntity.data!;
      } else {
        // Handle API error response
        return []; // or throw an exception, depending on your requirement
      }
    } catch (e) {
      print("Error fetching suggestion data: $e");
      // Return default response when an error occurs
      return [];
    }
  }
}
