import 'dart:math';
import '../domain/quote.dart';
import '../constants.dart';

class QuoteRepository {
  static final Random _random = Random();
  static final List<Quote> _quotes = [];
  static final List<String> _companyNames = [
    'Apple', 'Google', 'Microsoft', 'Amazon', 'Tesla',
    'Meta', 'Netflix', 'NVIDIA', 'Adobe', 'Salesforce',
    'Oracle', 'IBM', 'Intel', 'Samsung', 'Sony',
    'Spotify', 'PayPal', 'Twitter', 'Uber', 'Airbnb'
  ];

  Future<List<Quote>> getPaginatedQuotes(int page) async {
    await Future.delayed(const Duration(seconds: 2));
    
    return List.generate(QuoteConstants.pageSize, (index) => _generateRandomQuote());
  }

  Quote _generateRandomQuote(){
    return Quote(
      companyName: _companyNames[_random.nextInt(_companyNames.length)]+" # ${_random.nextInt(20)}",
      stockPrice: 100 + _random.nextDouble() * 1000,
      changePercentage: (_random.nextDouble() * 200 - 100),
      lastUpdated: DateTime.now().subtract(Duration(minutes: _random.nextInt(60))),
    );
  }
  void addQuote(Quote newQuote) {
    _quotes.add(newQuote);
  }
  Future<List<Quote>> fetchQuotes() async {
    await Future.delayed(const Duration(seconds: 2));
    return _quotes;

  }
}





