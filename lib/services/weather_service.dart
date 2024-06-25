// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter_proyektes2/const_resource.dart';
import 'package:flutter_proyektes2/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://weatherapi-com.p.rapidapi.com/current.json';

  String? _cityName;

  

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName'),
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _cityName = data['location']['name'];
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  String? getCity() {
    if (_cityName != null) {
      return _cityName;
    } else {
      throw Exception(
          'City data not available. Please fetch the weather data first.');
    }
  }

  
}
