import 'package:afranco/components/connectivity/connectivity_wrapper.dart';
import 'package:afranco/components/welcome/quick_access_card.dart';
import 'package:afranco/views/noticia_screen.dart';
import 'package:afranco/views/quote_screen.dart';
import 'package:afranco/views/task_screen.dart';
import 'package:afranco/views/categoria_screen.dart';
import 'package:flutter/material.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acceso Rápido',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            QuickAccessCard(
              icon: Icons.task_alt,
              title: 'Tareas',
              subtitle: 'Gestiona tus tareas',
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TasksScreen()),
              ),
            ),
            QuickAccessCard(
              icon: Icons.newspaper,
              title: 'Noticias',
              subtitle: 'Últimas noticias',
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConnectivityWrapper(
                    child: NoticiaScreen(),
                  ),
                ),
              ),
            ),
            QuickAccessCard(
              icon: Icons.trending_up,
              title: 'Cotizaciones',
              subtitle: 'Precios actuales',
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuoteScreen()),
              ),
            ),
            QuickAccessCard(
              icon: Icons.category,
              title: 'Categorías',
              subtitle: 'Organiza contenido',
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConnectivityWrapper(
                    child: CategoriaScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}