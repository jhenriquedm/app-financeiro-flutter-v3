class MarketModel {
  final String code;
  final String name;
  final double bid;
  final double ask;
  final double high;
  final double low;
  final double variation;
  final double percentageChange;
  final String updatedAt;

  MarketModel({
    required this.code,
    required this.name,
    required this.bid,
    required this.ask,
    required this.high,
    required this.low,
    required this.variation,
    required this.percentageChange,
    required this.updatedAt,
  });

  factory MarketModel.fromMap(Map<String, dynamic> map) {
    return MarketModel(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      bid: double.tryParse(map['bid']?.toString() ?? '0') ?? 0,
      ask: double.tryParse(map['ask']?.toString() ?? '0') ?? 0,
      high: double.tryParse(map['high']?.toString() ?? '0') ?? 0,
      low: double.tryParse(map['low']?.toString() ?? '0') ?? 0,
      variation: double.tryParse(map['varBid']?.toString() ?? '0') ?? 0,
      percentageChange:
          double.tryParse(map['pctChange']?.toString() ?? '0') ?? 0,
      updatedAt: map['create_date'] ?? '',
    );
  }
}