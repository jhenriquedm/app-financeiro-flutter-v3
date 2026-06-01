import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/market_model.dart';

class MarketService {
  Future<List<MarketModel>> getMarketQuotes() async {
    final uri = Uri.parse(
      'https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL,BTC-BRL',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar cotações do mercado.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return [
      MarketModel.fromMap(data['USDBRL']),
      MarketModel.fromMap(data['EURBRL']),
      MarketModel.fromMap(data['BTCBRL']),
    ];
  }
}