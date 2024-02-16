import 'package:clean_architecture/core/params/forecast_params.dart';
import 'package:clean_architecture/core/utils/constants.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  final Dio _dio = Dio();

  var apiKey = Constants.apiKeys1;

  Future<dynamic> callCurrentWeather(cityName) async {
    var response = await _dio.get('${Constants.baseUrl}/data/2.5/weather',
        queryParameters: {'q': cityName, 'appid': apiKey, 'units': 'metric'});
    // print(response.data);
    return response;
  }

  Future<dynamic> sendRequest7DaysForeCast(ForecastParams params) async {
    var response = await _dio.get('${Constants.baseUrl}/data/2.5/forecast',
        queryParameters: {
          'lat': params.lat,
          'lon': params.lon,
          'cnt': '40',
          'appid': apiKey,
          'units': 'metric'
        },
        );
    // print("forecastttttt${response.data}");
    return response;
  }

  Future<dynamic> sendRequestCitySuggestion(String prefix)async{

    // // Introduce a delay before making the next request for handling 429 error
    // await Future.delayed(const Duration(seconds: 1));

    var response = await _dio.get('https://wft-geo-db.p.rapidapi.com/v1/geo/cities',
        queryParameters: {
      'limit': 4,
      'offset': 2,
      'namePrefix': prefix,
    },options: Options(
            headers: {
              'X-RapidAPI-Key': '78a15d964emsh53b2f18cb175ea8p18b51fjsnb0f38f1a2d6d',
              'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com'
            }
        )
   );

    print(response.data);
    return response;
  }




}
