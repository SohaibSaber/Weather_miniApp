import 'package:clean_architecture/features/feature_weather/domain/entities/forecast_days_entity.dart';

/// cod : "200"
/// message : 0
/// cnt : 40
/// list : [{"dt":1661871600,"main":{"temp":296.76,"feels_like":296.98,"temp_min":296.76,"temp_max":297.87,"pressure":1015,"sea_level":1015,"grnd_level":933,"humidity":69,"temp_kf":-1.11},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"clouds":{"all":100},"wind":{"speed":0.62,"deg":349,"gust":1.18},"visibility":10000,"pop":0.32,"rain":{"3h":0.26},"sys":{"pod":"d"},"dt_txt":"2022-08-30 15:00:00"},{"dt":1661882400,"main":{"temp":295.45,"feels_like":295.59,"temp_min":292.84,"temp_max":295.45,"pressure":1015,"sea_level":1015,"grnd_level":931,"humidity":71,"temp_kf":2.61},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10n"}],"clouds":{"all":96},"wind":{"speed":1.97,"deg":157,"gust":3.39},"visibility":10000,"pop":0.33,"rain":{"3h":0.57},"sys":{"pod":"n"},"dt_txt":"2022-08-30 18:00:00"},{"dt":1661893200,"main":{"temp":292.46,"feels_like":292.54,"temp_min":290.31,"temp_max":292.46,"pressure":1015,"sea_level":1015,"grnd_level":931,"humidity":80,"temp_kf":2.15},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10n"}],"clouds":{"all":68},"wind":{"speed":2.66,"deg":210,"gust":3.58},"visibility":10000,"pop":0.7,"rain":{"3h":0.49},"sys":{"pod":"n"},"dt_txt":"2022-08-30 21:00:00"},{"dt":1662292800,"main":{"temp":294.93,"feels_like":294.83,"temp_min":294.93,"temp_max":294.93,"pressure":1018,"sea_level":1018,"grnd_level":935,"humidity":64,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":{"all":88},"wind":{"speed":1.14,"deg":17,"gust":1.57},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2022-09-04 12:00:00"}]
/// city : {"id":3163858,"name":"Zocca","coord":{"lat":44.34,"lon":10.99},"country":"IT","population":4593,"timezone":7200,"sunrise":1661834187,"sunset":1661882248}

class ForecastModel extends ForecastDaysEntity {
  ForecastModel(
      {String? cod,
      int? message,
      int? cnt,
      List<Datalist>? datalist,
      City? city})
      : super(
            cod: cod,
            message: message,
            cnt: cnt,
            datalist: datalist,
            city: city);

  factory ForecastModel.fromJson(dynamic json) {
    List<Datalist> datalist = [];
    if (json['list'] != null) {
      json['list'].forEach((v) {
        datalist.add(Datalist.fromJson(v));
      });
    }
    return ForecastModel(
      cod: json['cod'],
      message: json['message'],
      cnt: json['cnt'],
      datalist: datalist,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cod'] = cod;
    map['message'] = message;
    map['cnt'] = cnt;
    if (datalist != null) {
      map['list'] = datalist?.map((v) => v.toJson()).toList();
    }
    if (city != null) {
      map['city'] = city?.toJson();
    }
    return map;
  }
}

/// id : 3163858
/// name : "Zocca"
/// coord : {"lat":44.34,"lon":10.99}
/// country : "IT"
/// population : 4593
/// timezone : 7200
/// sunrise : 1661834187
/// sunset : 1661882248

class City {
  City({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
    this.sunrise,
    this.sunset,
  });

  City.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    coord = json['coord'] != null ? Coord.fromJson(json['coord']) : null;
    country = json['country'];
    population = json['population'];
    timezone = json['timezone'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  int? id;
  String? name;
  Coord? coord;
  String? country;
  int? population;
  int? timezone;
  int? sunrise;
  int? sunset;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (coord != null) {
      map['coord'] = coord?.toJson();
    }
    map['country'] = country;
    map['population'] = population;
    map['timezone'] = timezone;
    map['sunrise'] = sunrise;
    map['sunset'] = sunset;
    return map;
  }
}

/// lat : 44.34
/// lon : 10.99

class Coord {
  Coord({
    this.lat,
    this.lon,
  });

  factory Coord.fromJson(dynamic json) {
    return Coord(
      lat: json['lat']?.toDouble(),
      lon: json['lon']?.toDouble(),
    );
  }

  double? lat;
  double? lon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lon'] = lon;
    return map;
  }
}

/// dt : 1661871600
/// main : {"temp":296.76,"feels_like":296.98,"temp_min":296.76,"temp_max":297.87,"pressure":1015,"sea_level":1015,"grnd_level":933,"humidity":69,"temp_kf":-1.11}
/// weather : [{"id":500,"main":"Rain","description":"light rain","icon":"10d"}]
/// clouds : {"all":100}
/// wind : {"speed":0.62,"deg":349,"gust":1.18}
/// visibility : 10000
/// pop : 0.32
/// rain : {"3h":0.26}
/// sys : {"pod":"d"}
/// dt_txt : "2022-08-30 15:00:00"

class Datalist {
  Datalist({
    this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
    this.rain,
    this.sys,
    this.dtTxt,
  });

  factory Datalist.fromJson(dynamic json) {
    return Datalist(
      dt: json['dt'],
      main: json['main'] != null ? Main.fromJson(json['main']) : null,
      weather: json['weather'] != null
          ? List<Weather>.from(json['weather'].map((v) => Weather.fromJson(v)))
          : null,
      clouds: json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null,
      wind: json['wind'] != null ? Wind.fromJson(json['wind']) : null,
      visibility: json['visibility'],
      pop: json['pop']?.toDouble(),
      rain: json['rain'] != null ? Rain.fromJson(json['rain']) : null,
      sys: json['sys'] != null ? Sys.fromJson(json['sys']) : null,
      dtTxt: json['dt_txt'],
    );
  }

  int? dt;
  Main? main;
  List<Weather>? weather;
  Clouds? clouds;
  Wind? wind;
  int? visibility;
  double? pop;
  Rain? rain;
  Sys? sys;
  String? dtTxt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dt'] = dt;
    if (main != null) {
      map['main'] = main?.toJson();
    }
    if (weather != null) {
      map['weather'] = weather?.map((v) => v.toJson()).toList();
    }
    if (clouds != null) {
      map['clouds'] = clouds?.toJson();
    }
    if (wind != null) {
      map['wind'] = wind?.toJson();
    }
    map['visibility'] = visibility;
    map['pop'] = pop;
    if (rain != null) {
      map['rain'] = rain?.toJson();
    }
    if (sys != null) {
      map['sys'] = sys?.toJson();
    }
    map['dt_txt'] = dtTxt;
    return map;
  }
}

/// pod : "d"

class Sys {
  Sys({
    this.pod,
  });

  Sys.fromJson(dynamic json) {
    pod = json['pod'];
  }

  String? pod;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pod'] = pod;
    return map;
  }
}

/// 3h : 0.26

class Rain {
  Rain({
    this.h,
  });

  factory Rain.fromJson(dynamic json) {
    return Rain(
      h: json['3h']?.toDouble(),
    );
  }

  double? h;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['3h'] = h;
    return map;
  }
}

/// speed : 0.62
/// deg : 349
/// gust : 1.18

class Wind {
  Wind({
    this.speed,
    this.deg,
    this.gust,
  });

  factory Wind.fromJson(dynamic json) {
    return Wind(
      speed: json['speed']?.toDouble(),
      deg: json['deg'],
      gust: json['gust']?.toDouble(),
    );
  }

  double? speed;
  int? deg;
  double? gust;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['speed'] = speed;
    map['deg'] = deg;
    map['gust'] = gust;
    return map;
  }
}

/// all : 100

class Clouds {
  Clouds({
    this.all,
  });

  Clouds.fromJson(dynamic json) {
    all = json['all'];
  }

  int? all;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['all'] = all;
    return map;
  }
}

/// id : 500
/// main : "Rain"
/// description : "light rain"
/// icon : "10d"

class Weather {
  Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  Weather.fromJson(dynamic json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  int? id;
  String? main;
  String? description;
  String? icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['main'] = main;
    map['description'] = description;
    map['icon'] = icon;
    return map;
  }
}

/// temp : 296.76
/// feels_like : 296.98
/// temp_min : 296.76
/// temp_max : 297.87
/// pressure : 1015
/// sea_level : 1015
/// grnd_level : 933
/// humidity : 69
/// temp_kf : -1.11

class Main {
  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.seaLevel,
    this.grndLevel,
    this.humidity,
    this.tempKf,
  });

  factory Main.fromJson(dynamic json) {
    return Main(
      temp: json['temp']?.toDouble(),
      feelsLike: json['feels_like']?.toDouble(),
      tempMin: json['temp_min']?.toDouble(),
      tempMax: json['temp_max']?.toDouble(),
      pressure: json['pressure'],
      seaLevel: json['sea_level'],
      grndLevel: json['grnd_level'],
      humidity: json['humidity'],
      tempKf: json['temp_kf']?.toDouble(),
    );
  }

  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;
  int? pressure;
  int? seaLevel;
  int? grndLevel;
  int? humidity;
  double? tempKf;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['temp'] = temp;
    map['feels_like'] = feelsLike;
    map['temp_min'] = tempMin;
    map['temp_max'] = tempMax;
    map['pressure'] = pressure;
    map['sea_level'] = seaLevel;
    map['grnd_level'] = grndLevel;
    map['humidity'] = humidity;
    map['temp_kf'] = tempKf;
    return map;
  }
}
