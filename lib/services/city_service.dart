import 'dart:convert';
import 'package:flutter_proyektes2/models/city_model.dart';
import 'package:http/http.dart' as http;

class CityService {
  Future<List<City>> getCityNames() async {
    final response = await http.get(
      Uri.parse('https://referential.p.rapidapi.com/v1/city?limit=250'),
      headers: {
        'X-RapidAPI-Key': '46a87d38bfmsh1962f415e6cce83p1ed293jsn9e6ecbc46c3f',
        'X-RapidAPI-Host': 'referential.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<City> data = jsonResponse.map((e) => City.fromJson(e)).toList();
      return data;
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
