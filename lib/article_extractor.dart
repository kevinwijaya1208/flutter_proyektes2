//API BUAT BACA ISI LINK
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchArticleSummary(String articleUrl) async {
  final String apiUrl = "https://news-article-data-extract-and-summarization1.p.rapidapi.com/extract/";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'x-rapidapi-key': '1412490959mshfc3094498a0cc60p16b84cjsnb755d53913d3',
        'x-rapidapi-host': 'news-article-data-extract-and-summarization1.p.rapidapi.com',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'url': articleUrl}),
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = jsonDecode(response.body);
      return jsonResponse['text'] ?? 'No summary available';
    } else {
      throw Exception('Failed to load article summary');
    }
  } catch (e) {
    throw Exception('Failed to fetch article summary: $e');
  }
}
