import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tdd_flutter/core/constants/constants.dart';
import 'package:tdd_flutter/data/data_sources/remote_data_source.dart';
import 'package:tdd_flutter/data/models/weather_model.dart';

import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late WeatherRemoteDataSourceImpl weatherRemoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    weatherRemoteDataSourceImpl =
        WeatherRemoteDataSourceImpl(client: mockHttpClient);
  });

  const testCityName = 'New York';

  group('get current weather', () {
    test('should return weather model the response code is 200', () async {
      //arrange
      when(mockHttpClient
              .get(Uri.parse(Urls.currentWeatherByName(testCityName))))
          .thenAnswer((_) async => http.Response(
              readJson('helpers/dummy_data/dummy_weather_response.json'), 200));
      //act
      final result = await weatherRemoteDataSourceImpl.getCurrentWeather(testCityName);

      //assert
      expect(result, isA<WeatherModel>());
    });
  });
}