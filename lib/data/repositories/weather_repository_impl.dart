import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tdd_flutter/core/error/exception.dart';
import 'package:tdd_flutter/core/error/failure.dart';
import 'package:tdd_flutter/data/data_sources/remote_data_source.dart';
import 'package:tdd_flutter/domain/entities/weather.dart';
import 'package:tdd_flutter/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;
  WeatherRepositoryImpl({required this.weatherRemoteDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String cityName) async {
    try {
      final result = await weatherRemoteDataSource.getCurrentWeather(cityName);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure('An error has occured'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}