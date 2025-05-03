import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String apiKey = 'f9c2762e12fe46bb8a560310d9fe3025';

  Future<double> convertUSDTo(String targetCurrency) async {
    final url = Uri.parse(
      'http://api.currencylayer.com/live?access_key=$apiKey&currencies=$targetCurrency&source=USD&format=1',
    );
    final response = await http.get(url);
    final data = json.decode(response.body);
    return data['quotes']['USD$targetCurrency'] ?? 1.0;
  }
}
