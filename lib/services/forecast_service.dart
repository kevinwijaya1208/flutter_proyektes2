import 'dart:convert';
import 'package:flutter_proyektes2/const_resource.dart';
import 'package:flutter_proyektes2/models/forecast_model.dart';
import 'package:http/http.dart' as http;

class ForecastService {
  static const BASE_URL = 'https://weatherapi-com.p.rapidapi.com/current.json';

  Future<Forecast> getWeatherForecast(String city) async {
    final response = await http.get(
      Uri.parse(
          'https://weatherapi-com.p.rapidapi.com/forecast.json?q=$city&days=3'),
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      Forecast data = Forecast.fromJson(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }
}
