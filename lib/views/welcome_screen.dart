import 'package:afranco/bloc/counter/counter_bloc.dart';
import 'package:afranco/views/categoria_screen.dart';
import 'package:afranco/views/noticia_screen.dart';
import 'package:afranco/views/pantalla_interactiva.dart';
import 'package:afranco/views/quote_screen.dart';
import 'package:afranco/views/login_screen.dart';
import 'package:afranco/views/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:afranco/views/tasks.dart'; // Mantén esta línea
import 'package:afranco/main.dart';
import 'package:afranco/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        automaticallyImplyLeading: true, // Muestra el botón de menú hamburguesa
      ),
drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.teal),
        child: Text(
          'Menú de Navegación',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.task),
        title: const Text(AppConstants.titleAppBarT),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TasksScreen()),
          );
        },
      ),
      // Nuevo botón para Pantalla Principal
      ListTile(
        leading: const Icon(Icons.restart_alt),
        title: const Text('Contador'),
        onTap: () {
          Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider<CounterBloc>(
              create: (context) => CounterBloc(),
              child: const MyHomePage(title: 'Counter App'),
            ),
        ),
    );
        },
      ),
      ListTile(
        leading: const Icon(Icons.emoji_events),
        title: const Text(GameConstants.titleApp),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StartScreen()),
            
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.money),
        title: const Text('Cotizaciones'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuoteScreen()),
            
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.newspaper),
        title: const Text('Noticias'),
        onTap: () {
          Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider<CounterBloc>(
              create: (context) => CounterBloc(),
              child: NoticiaScreen(),
            ),
        ),
    );
          
        },
      ),
  
      ListTile(
        leading: const Icon(Icons.palette_outlined),
        title: const Text('Colores'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ColorChangerScreen()),
            
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.category),
        title: const Text('Categorías'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CategoriaScreen()),
            
          );
        },
      ),

      ListTile(
        leading: const Icon(Icons.exit_to_app),
        title: const Text('Salir'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen()),
            
          );
        },
      ),


    ],
  ),
),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            Text(
              '¡Bienvenido!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Has iniciado sesión exitosamente',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TasksScreen(),
                  ),
                );
              },
              child: const Text('Lista de Tareas'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
              // Navega a LoginScreen usando Navigator
              Navigator.push(
                context, // Necesitas el contexto aquí
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Volver al Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}