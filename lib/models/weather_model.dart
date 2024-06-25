// ignore_for_file: unused_import

import 'package:flutter/material.dart';

class Weather {
  final String cityName;
  final double temp;
  final String mainCondition;

  Weather(
      {required this.cityName,
      required this.temp,
      required this.mainCondition});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['location']['name'],
      temp: json['current']['temp_c'].toDouble(),
      mainCondition: json['current']['condition']['text'],
    );
  }
}

