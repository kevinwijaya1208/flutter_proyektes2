class City {
  String value;
  String key;

  City({
    required this.value,
    required this.key,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        value: json["value"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "key": key,
      };
}
