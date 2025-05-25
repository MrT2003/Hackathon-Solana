// lib/services/solana_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class SolanaService {
  Future<int?> getTokenBalance(String pubKey) async {
    final url =
        Uri.parse('http://localhost:5000/solana/getTokenBalance/$pubKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return jsonBody['balance'];
    } else {
      print('Failed to load balance');
      return null;
    }
  }
}
