class Forecast {
  Location location;
  ForecastClass forecast;

  Forecast({
    required this.location,
    required this.forecast,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
        location: Location.fromJson(json["location"]),
        forecast: ForecastClass.fromJson(json["forecast"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "forecast": forecast.toJson(),
      };
}

class ForecastClass {
  List<Forecastday> forecastday;

  ForecastClass({
    required this.forecastday,
  });

  factory ForecastClass.fromJson(Map<String, dynamic> json) => ForecastClass(
        forecastday: List<Forecastday>.from(
            json["forecastday"].map((x) => Forecastday.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "forecastday": List<dynamic>.from(forecastday.map((x) => x.toJson())),
      };
}

class Forecastday {
  DateTime date;
  Day day;
  int? dateEpoch;

  Forecastday({
    required this.date,
    required this.day,
    this.dateEpoch,
  });

  factory Forecastday.fromJson(Map<String, dynamic> json) => Forecastday(
        date: DateTime.parse(json["date"]),
        day: Day.fromJson(json["day"]),
        dateEpoch: json["date_epoch"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "day": day.toJson(),
        "date_epoch": dateEpoch,
      };
}

class Day {
  Condition condition;
  double temp;
  Day({required this.condition, required this.temp});

  factory Day.fromJson(Map<String, dynamic> json) => Day(
      condition: Condition.fromJson(json["condition"]),
      temp: json['avgtemp_c']);

  Map<String, dynamic> toJson() => {
        "condition": condition.toJson(),
      };
}

class Condition {
  String text;

  Condition({
    required this.text,
  });

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}

class Location {
  String name;

  Location({
    required this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
