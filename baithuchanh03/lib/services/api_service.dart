import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/meal.dart';

class ApiService {
  static const _baseUrl = 'www.themealdb.com';

  /// Fetch meals starting with the letter 'a'.
  ///
  /// Throws any exception it receives so the caller can handle it.
  Future<List<Meal>> fetchMeals() async {
    try {
      final uri = Uri.https(_baseUrl, '/api/json/v1/1/search.php', {'f': 'a'});
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body) as Map<String, dynamic>;
        final mealsJson = data['meals'] as List<dynamic>?;
        if (mealsJson == null) {
          return [];
        }
        return mealsJson
            .map((e) => Meal.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Server returned status ${resp.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
