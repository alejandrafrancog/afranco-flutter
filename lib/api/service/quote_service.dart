import '../../domain/quote.dart';
import '../../data/quote_repository.dart';

/// QuoteService is responsible for managing the business logic related to quotes.
class QuoteService {
  final QuoteRepository _repository = QuoteRepository();
  QuoteService({ QuoteRepository? repository });

  Future<List<Quote>> fetchQuotes() async {
    return await _repository.fetchQuotes();
  }
  
  void addQuote(Quote newQuote) {
    _repository.addQuote(newQuote);
  }
 Future<List<Quote>> getPaginatedQuotes(int page) async {
  // 1. Obtener nuevas quotes (el repositorio ya las guarda internamente)
  await _repository.getPaginatedQuotes(page);
  
  // 2. Obtener TODAS las quotes acumuladas
  final allQuotes = await _repository.fetchQuotes();
  
  // 3. Ordenar la lista completa
  allQuotes.sort((a, b) => b.stockPrice.compareTo(a.stockPrice));
  
  return allQuotes;
}
  
}
