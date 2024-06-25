// // ignore_for_file: await_only_futures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_proyektes2/components/date_format.dart';
import 'package:flutter_proyektes2/models/city_model.dart';
import 'package:flutter_proyektes2/models/forecast_model.dart';
import 'package:flutter_proyektes2/models/weather_model.dart';
import 'package:flutter_proyektes2/services/city_service.dart';
import 'package:flutter_proyektes2/services/forecast_service.dart';
import 'package:flutter_proyektes2/services/weather_service.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class CustomSearchDelegate extends SearchDelegate<String?> {
  List<String> searchTerms = [];

  CustomSearchDelegate() {
    _fetchCity();
  }

  Future<void> _fetchCity() async {
    final url = Uri.parse(
        'https://nomadlist-digital-nomad-travel-api.p.rapidapi.com/cities?orderBy=total_score&order=desc&page=1&limit=10');

    try {
      final response = await http.get(
        url,
        headers: {
          'X-Rapidapi-Key': '1412490959mshfc3094498a0cc60p16b84cjsnb755d53913d3',
          'X-Rapidapi-Host': 'nomadlist-digital-nomad-travel-api.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['cities'];
        if (data.isNotEmpty) {
          searchTerms = data.map((item) => item['name'] as String).toList();
        }
      } else {
        print('Failed to load city data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var city in searchTerms) {
      if (city.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(city);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context, result);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var city in searchTerms) {
      if (city.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(city);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            query = result;
            showResults(context);
          },
        );
      },
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _weather;
  Forecast? _forecast;
  String _city = 'Surabaya';

  Future<void> _fetchWeather(String city) async {
    try {
      final weather = await WeatherService().getWeather(city);
      final forecast = await ForecastService().getWeatherForecast(city);
      setState(() {
        _weather = weather;
        _forecast = forecast;
        _city = city;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'lib/images/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return 'lib/images/sunny.json';
      case 'partly cloudy':
      case 'cloudy':
      case 'overcast':
      case 'fog':
      case 'freezing fog':
        return 'lib/images/cloudy.json';
      case 'mist':
        return 'lib/images/mist.json';
      case 'patchy rain possible':
      case 'patchy freezing drizzle possible':
      case 'patchy light drizzle':
      case 'light drizzle':
      case 'freezing drizzle':
      case 'heavy freezing drizzle':
      case 'patchy light rain':
      case 'light rain':
      case 'moderate rain at times':
      case 'moderate rain':
      case 'heavy rain at times':
      case 'heavy rain':
      case 'light freezing rain':
      case 'moderate or heavy freezing rain':
      case 'light rain shower':
      case 'torrential rain shower':
      case 'patchy light rain':
        return 'lib/images/rain.json';
      case 'patchy snow possible':
      case 'patchy sleet possible':
      case 'blowing snow':
      case 'blizzard':
      case 'light sleet':
      case 'moderate or heavy sleet':
      case 'patchy light snow':
      case 'light snow':
      case 'moderate snow':
      case 'patchy moderate snow':
      case 'patchy heavy snow':
      case 'heavy snow':
      case 'ice pellets':
      case 'light sleet showers':
      case 'moderate or heavy sleet showers':
      case 'light snow showers':
      case 'moderate or heavy snow showers':
      case 'light showers of ice pellets':
      case 'moderate or heavy showers of ice pellets':
        return 'lib/images/snow.json';
      case 'patchy light rain with thunder':
      case 'moderate or heavy rain with thunder':
      case 'patchy light snow with thunder':
      case 'moderate or heavy snow with thunder':
      case 'thundery outbreaks possible':
        return 'lib/images/storm.json';
      default:
        return 'lib/images/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(_city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        final result = await showSearch<String?>(
                          context: context,
                          delegate: CustomSearchDelegate(),
                        );
                        if (result != null) {
                          _fetchWeather(result);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Text(_weather?.cityName ?? "loading city..."),
              SizedBox(height: 50),
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              SizedBox(height: 50),
              Text('${_weather?.temp.round()}°C'),
              Text(_weather?.mainCondition ?? ""),
              SizedBox(height: 50),
              if (_forecast != null) ...[
                Text(
                  "3-Day Forecast",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  color: Colors.white,
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: _forecast!.forecast.forecastday.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width /
                            _forecast!.forecast.forecastday.length,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(formatDate2(
                                _forecast!.forecast.forecastday[index].date)),
                            Lottie.asset(
                              getWeatherAnimation(_forecast!.forecast
                                  .forecastday[index].day.condition.text),
                              width: 50,
                              height: 50,
                            ),
                            Text(
                                '${_forecast!.forecast.forecastday[index].day.temp.round()}°C'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

