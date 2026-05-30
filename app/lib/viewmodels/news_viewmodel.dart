import 'package:flutter/material.dart';

import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsService _newsService;

  NewsViewModel({
    required NewsService newsService,
  }) : _newsService = newsService;

  List<NewsModel> _news = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NewsModel> get news => _news;
  bool get isLoading => _isLoading;
  String? get errorMessage =>
      _errorMessage;

  Future<void> loadNews() async {
    _setLoading(true);

    try {
      _news =
          await _newsService
              .getFinancialNews();

      _errorMessage = null;
    } catch (_) {
      _errorMessage =
          'Erro ao carregar notícias.';
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}