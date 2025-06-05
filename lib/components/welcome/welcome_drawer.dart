import 'package:afranco/bloc/counter_bloc/counter_bloc.dart';
import 'package:afranco/components/connectivity/connectivity_wrapper.dart';
import 'package:afranco/components/welcome/drawer_menu_item.dart';
import 'package:afranco/theme/theme.dart';
import 'package:afranco/views/acerca_de_screen.dart';
import 'package:afranco/views/categoria_screen.dart';
import 'package:afranco/views/noticia_screen.dart';
import 'package:afranco/views/pantalla_interactiva.dart';
import 'package:afranco/views/quote_screen.dart';
import 'package:afranco/views/login_screen.dart';
import 'package:afranco/views/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:afranco/views/task_screen.dart';
import 'package:afranco/main.dart';
import 'package:afranco/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeDrawer extends StatelessWidget {
  final String username;
  final DateTime loggedInAt = DateTime.now();
  WelcomeDrawer({super.key, required this.username,loggedInAt});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerMenuItem(
                  icon: Icons.task,
                  title: AppConstantes.titleAppBarT,
                  onTap: () => _navigateToScreen(context, const TasksScreen()),
                ),
                DrawerMenuItem(
                  icon: Icons.restart_alt,
                  title: 'Contador',
                  onTap: () => _navigateToCounterScreen(context),
                ),
                DrawerMenuItem(
                  icon: Icons.emoji_events,
                  title: GameConstants.titleApp,
                  onTap: () => _navigateToScreen(context, const StartScreen()),
                ),
                DrawerMenuItem(
                  icon: Icons.money,
                  title: 'Cotizaciones',
                  onTap: () => _navigateToScreen(context, const QuoteScreen()),
                ),
                DrawerMenuItem(
                  icon: Icons.newspaper,
                  title: 'Noticias',
                  onTap:
                      () => _navigateToConnectivityScreen(
                        context,
                        NoticiaScreen(),
                      ),
                ),
                DrawerMenuItem(
                  icon: Icons.palette_outlined,
                  title: 'Colores',
                  onTap:
                      () => _navigateToScreen(
                        context,
                        const ColorChangerScreen(),
                      ),
                ),
                DrawerMenuItem(
                  icon: Icons.category,
                  title: 'Categorias',
                  onTap:
                      () => _navigateToConnectivityScreen(
                        context,
                        const CategoriaScreen(),
                      ),
                ),
                DrawerMenuItem(
                  icon: Icons.info,
                  title: 'Acerca de',
                  onTap:
                      () => _navigateToScreen(context, const AcercaDeScreen()),
                ),
                const Divider(),
                DrawerMenuItem(
                  icon: Icons.exit_to_app,
                  title: 'Salir',
                  textColor: Theme.of(context).primaryColor,
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      height: 120,
      decoration: AppTheme.drawerHeaderDecoration,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Theme.of(context).primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Text(
              username.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _navigateToConnectivityScreen(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close drawer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConnectivityWrapper(child: screen),
      ),
    );
  }

  void _navigateToCounterScreen(BuildContext context) {
    Navigator.pop(context); // Close drawer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocProvider<CounterBloc>(
              create: (context) => CounterBloc(),
              child: const MyHomePage(title: 'Contador'),
            ),
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const ConnectivityWrapper(child: LoginScreen()),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
