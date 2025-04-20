import 'package:flutter/material.dart';
import 'package:afranco/domain/quote.dart';
import 'package:afranco/api/service/quote_service.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  QuoteScreenState createState() => QuoteScreenState();
}

class QuoteScreenState extends State<QuoteScreen> {
  final List<Quote> _quotes = [];
  final QuoteService _service = QuoteService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;
  final double spacingHeight = 10; // Variable para el espacio entre Cards

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadMoreQuotes();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreQuotes();
    }
  }

  Future<void> _loadMoreQuotes() async {
    if (_isLoading || !_hasMore) return;
    
    setState(() => _isLoading = true);
    
    try {
      final newQuotes = await _service.getPaginatedQuotes(_currentPage);
      
      setState(() {
        _quotes.addAll(newQuotes);
        _currentPage++;
        _hasMore = newQuotes.isNotEmpty;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cotizaciones en Tiempo Real')),
      backgroundColor: Colors.grey[200], // Fondo gris claro
      body: ListView.separated(
        controller: _scrollController,
        itemCount: _quotes.length + (_isLoading ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: spacingHeight), // Espacio entre Cards
        itemBuilder: (context, index) {
          if (index >= _quotes.length) {
            return _buildLoader();
          }
          return _buildQuoteCard(_quotes[index]);
        },
      ),
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildQuoteCard(Quote quote) {
    final isPositive = quote.changePercentage >= 0;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8), // Ajuste de márgenes
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  quote.companyName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${quote.changePercentage.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Precio: \$${quote.stockPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Actualizado: ${_formatDate(quote.lastUpdated)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}