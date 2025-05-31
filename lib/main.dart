import 'package:afranco/bloc/auth_bloc/auth_bloc.dart';
import 'package:afranco/bloc/categoria_bloc/categoria_bloc.dart';
import 'package:afranco/bloc/comentario_bloc/comentario_bloc.dart';
import 'package:afranco/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:afranco/bloc/counter_bloc/counter_bloc.dart';
import 'package:afranco/bloc/noticia_bloc/noticia_bloc.dart';
import 'package:afranco/bloc/preferencia_bloc/preferencia_bloc.dart';
import 'package:afranco/bloc/reporte_bloc/reporte_bloc.dart';
import 'package:afranco/bloc/tarea_bloc/tareas_bloc.dart';
import 'package:afranco/bloc/tarea_contador_bloc/tarea_contador_bloc.dart';
import 'package:afranco/components/connectivity/connectivity_wrapper.dart';
import 'package:afranco/di/locator.dart';
import 'package:afranco/domain/comentario.dart';
import 'package:afranco/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:afranco/views/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  
  await initLocator();

  ComentarioMapper.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(create: (context) => CounterBloc()),
        BlocProvider<NoticiaBloc>(create: (context) => NoticiaBloc()),
        BlocProvider<CategoriaBloc>(create: (context) => CategoriaBloc()),
        BlocProvider<PreferenciaBloc>(create: (context) => PreferenciaBloc()),
        BlocProvider<ComentarioBloc>(create: (context) => ComentarioBloc()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ReporteBloc>(create: (context) => ReporteBloc()),
        BlocProvider<ConnectivityBloc>(create: (context) => ConnectivityBloc()),
        BlocProvider<TareasBloc>(create: (context) => TareasBloc()),
        BlocProvider<TareaContadorBloc>(create: (context) => TareaContadorBloc()),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      themeMode: ThemeMode.light,
            localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      home: const ConnectivityWrapper(child:LoginScreen()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title),
      ),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),
                Text(
                  '${state.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: state.color,
                  ),
                ),
                ElevatedButton(
                  style: AppTheme.lightTheme.elevatedButtonTheme.style,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Advertencia'),
                          content: const Text(
                            'Esta es una advertencia importante.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Mostrar Advertencia'),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'incrementButton',
            onPressed:
                () => context.read<CounterBloc>().add(IncrementCounter()),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'decrementButton',
            onPressed:
                () => context.read<CounterBloc>().add(DecrementCounter()),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'resetButton',
            onPressed: () => context.read<CounterBloc>().add(ResetCounter()),
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
