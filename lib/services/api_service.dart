import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '2be0cf812bd1bc731ccf5fcb'; 
  final String baseUrl = 'https://v6.exchangerate-api.com/v6/';

  Future<Map<String, dynamic>> getExchangeRates(String baseCurrency) async {
    final response = await http.get(Uri.parse('${baseUrl}${apiKey}/latest/$baseCurrency'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  Future<double> getConversionRate(String fromCurrency, String toCurrency) async {
    final rates = await getExchangeRates(fromCurrency);
    if (rates['conversion_rates'] != null && rates['conversion_rates'][toCurrency] != null) {
      return rates['conversion_rates'][toCurrency];
    } else {
      throw Exception('Conversion rate for $toCurrency not found');
    }
  }
}
