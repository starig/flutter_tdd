import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_flutter/core/error/failure.dart';
import 'package:tdd_flutter/domain/entities/weather.dart';
import 'package:tdd_flutter/presentation/bloc/weather_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase;
  late WeatherBloc weatherBloc;

  setUp(() {
    mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
    weatherBloc = WeatherBloc(mockGetCurrentWeatherUseCase);
  });

  const testWeather = WeatherEntity(
    cityName: 'New York',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  const testCityName = 'New York';

  test(
    'initial state should be empty',
    () {
      expect(weatherBloc.state, WeatherEmpty());
    },
  );

  blocTest<WeatherBloc, WeatherState>(
    'should emit WeatherLoading and WeatherLoaded when data is gotten',
    build: () {
      when(
        mockGetCurrentWeatherUseCase.execute(testCityName)
      ).thenAnswer((_) async => const Right(testWeather));
      return weatherBloc;
    },
    act: (bloc) {
      return bloc.add(const OnCityChanged(testCityName));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => <WeatherState>[
      WeatherLoading(),
      const WeatherLoaded(testWeather)
    ],
  );

  blocTest<WeatherBloc, WeatherState>(
    'should emit WeatherLoading and WeatherFailure when data is not gotten',
    build: () {
      when(
          mockGetCurrentWeatherUseCase.execute(testCityName)
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return weatherBloc;
    },
    act: (bloc) {
      return bloc.add(const OnCityChanged(testCityName));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => <WeatherState>[
      WeatherLoading(),
      const WeatherLoadFailure('Server failure'),
    ],
  );
}
