import 'package:equatable/equatable.dart';

import '../../data/models/forecast_model.dart';

class ForecastDaysEntity extends Equatable {
  final String? cod;
  final int? message;
  final int? cnt;
  final List<Datalist>? datalist;
  final City? city;

  const ForecastDaysEntity(
      {this.cod, this.message, this.cnt, this.datalist, this.city});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
