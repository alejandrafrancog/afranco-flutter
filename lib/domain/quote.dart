class Quote {
  final String companyName;
  final double stockPrice;
  final double changePercentage;
  DateTime lastUpdated = DateTime.now();
  Quote({
    required this.companyName,
    required this.stockPrice,
    required this.changePercentage,
    lastUpdated,
  });

  @override
  String toString() {
    return 'Quote{companyName: $companyName, stockPrice: $stockPrice, changePercentage: $changePercentage, $lastUpdated}';
  }
}