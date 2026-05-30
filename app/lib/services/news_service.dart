import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/news_model.dart';

class NewsService {
  static const _apiKey = 'demo';

  Future<List<NewsModel>>
      getFinancialNews() async {
    try {
      final uri = Uri.parse(
        'https://newsdata.io/api/1/news'
        '?apikey=$_apiKey'
        '&category=business'
        '&language=pt',
      );

      final response =
          await http.get(uri);

      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body);

        final results =
            data['results'] as List?;

        if (results != null &&
            results.isNotEmpty) {
          return results
              .map(
                (item) =>
                    NewsModel.fromMap(
                  item,
                ),
              )
              .toList();
        }
      }

      return _fallbackTips();
    } catch (_) {
      return _fallbackTips();
    }
  }

  List<NewsModel> _fallbackTips() {
    return [
      NewsModel(
        title:
            'Monte uma reserva de emergência',
        description:
            'Tenha pelo menos de 3 a 6 meses do seu custo de vida guardados.',
        url: '',
        imageUrl: '',
        source: 'Money Wise',
      ),
      NewsModel(
        title:
            'Organize seus gastos por categoria',
        description:
            'Separar alimentação, transporte e lazer ajuda no controle financeiro.',
        url: '',
        imageUrl: '',
        source: 'Money Wise',
      ),
      NewsModel(
        title:
            'Evite gastar mais do que ganha',
        description:
            'Mantenha suas despesas abaixo da sua renda mensal.',
        url: '',
        imageUrl: '',
        source: 'Money Wise',
      ),
      NewsModel(
        title:
            'Registre pequenas despesas',
        description:
            'Pequenos gastos diários impactam bastante no orçamento.',
        url: '',
        imageUrl: '',
        source: 'Money Wise',
      ),
      NewsModel(
        title:
            'Defina metas financeiras',
        description:
            'Planejar objetivos ajuda a manter o foco financeiro.',
        url: '',
        imageUrl: '',
        source: 'Money Wise',
      ),
    ];
  }
}