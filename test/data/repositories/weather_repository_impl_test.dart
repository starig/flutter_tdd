import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_flutter/core/error/exception.dart';
import 'package:tdd_flutter/core/error/failure.dart';
import 'package:tdd_flutter/data/models/weather_model.dart';
import 'package:tdd_flutter/data/repositories/weather_repository_impl.dart';
import 'package:tdd_flutter/domain/entities/weather.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockWeatherRemoteDataSource mockWeatherRemoteDataSource;
  late WeatherRepositoryImpl weatherRemoteDataSourceImpl;

  setUp(() {
    mockWeatherRemoteDataSource = MockWeatherRemoteDataSource();
    weatherRemoteDataSourceImpl = WeatherRepositoryImpl(
        weatherRemoteDataSource: mockWeatherRemoteDataSource);
  });

  const testWeatherModel = WeatherModel(
    cityName: 'New York',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  const testWeatherEntity = WeatherEntity(
    cityName: 'New York',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  const testCityName = 'New York';

  group(
    'get current weather',
    () {
      test(
          'should return current weather when a call to data source is success',
          () async {
        // arrange
        when(mockWeatherRemoteDataSource.getCurrentWeather(testCityName))
            .thenAnswer((_) async => testWeatherModel);
        // act
        final result =
            await weatherRemoteDataSourceImpl.getCurrentWeather(testCityName);

        // assert
        expect(result, equals(const Right(testWeatherEntity)));
      });

      test(
          'should return a server failure when a call to data source is not success',
          () async {
        // arrange
        when(mockWeatherRemoteDataSource.getCurrentWeather(testCityName))
            .thenThrow(ServerException());
        // act
        final result =
            await weatherRemoteDataSourceImpl.getCurrentWeather(testCityName);

        // assert
        expect(
            result, equals(const Left(ServerFailure('An error has occured'))));
      });

      test(
          'should return connection failure when the device has no internet',
              () async {
            // arrange
            when(mockWeatherRemoteDataSource.getCurrentWeather(testCityName))
                .thenThrow(const SocketException('Failed to connect to the network'));
            // act
            final result =
            await weatherRemoteDataSourceImpl.getCurrentWeather(testCityName);

            // assert
            expect(
                result, equals(const Left(ConnectionFailure('Failed to connect to the network'))));
          });
    },
  );
}
