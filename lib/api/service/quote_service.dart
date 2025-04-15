import '../../domain/quote.dart';
import '../../data/quote_repository.dart';

/// QuoteService is responsible for managing the business logic related to quotes.
class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  QuoteService({ QuoteRepository? repository });

  Future<List<Quote>> fetchQuotes() async {
    return await _repository.fetchQuotes();
  }
  Future<List<Quote>> getPaginatedQuotes(int page) async {
    return await _repository.getPaginatedQuotes(page);
  }
  void addQuote(Quote newQuote) {
    _repository.addQuote(newQuote);
  }

}
