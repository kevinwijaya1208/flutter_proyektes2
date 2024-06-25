//API BUAT NEWS
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiClient {
  static const String baseUrl = "https://newsapi90.p.rapidapi.com";
  static const String apiKey = "095f18298amsh70bcfbf81d92a31p141569jsnbb473630481b"; 

  Future<String> fetchNews(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search?query=$query&language=en-US'),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': 'newsapi90.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
