import 'package:flutter/material.dart';

import '../models/market_model.dart';
import '../services/market_service.dart';

class MarketViewModel extends ChangeNotifier {
  final MarketService _marketService;

  MarketViewModel({
    required MarketService marketService,
  }) : _marketService = marketService;

  List<MarketModel> _quotes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MarketModel> get quotes => _quotes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadQuotes() async {
    _setLoading(true);

    try {
      _quotes = await _marketService.getMarketQuotes();
      _errorMessage = null;
    } catch (_) {
      _errorMessage = 'Não foi possível carregar as cotações.';
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}