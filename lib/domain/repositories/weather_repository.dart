import 'package:dartz/dartz.dart';
import 'package:tdd_flutter/core/error/failure.dart';
import 'package:tdd_flutter/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String cityName);
}