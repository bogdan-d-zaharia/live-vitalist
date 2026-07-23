import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:live_vitalist/core/network/domain/network_interface.dart';

class HttpHandler implements INetwork {
  final String baseUrl;
  HttpHandler(this.baseUrl);

  @override
  Future<void> post(String path, dynamic data) async {
    final url = Uri.parse('$baseUrl/$path');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: data != null ? jsonEncode(data) : null,
      );

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> get(String path) async {
    final url = Uri.parse('$baseUrl/$path');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
