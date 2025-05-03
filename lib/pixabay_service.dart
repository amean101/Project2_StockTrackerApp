import 'dart:convert';
import 'package:http/http.dart' as http;

class PixabayService {
  final String apiKey = '50068526-7b0ea39472b933a3d12a09485';

  Future<List<String>> getInspirations(String query) async {
    final url = Uri.parse(
      'https://pixabay.com/api/?key=$apiKey&q=$query&image_type=photo',
    );
    final response = await http.get(url);
    final data = json.decode(response.body);
    return (data['hits'] as List)
        .map((e) => e['webformatURL'] as String)
        .toList();
  }
}
