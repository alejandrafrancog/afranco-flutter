import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../constants.dart';
import '../helpers/task_card_helper.dart';
import '../components/task_modals.dart';
import '../data/task_repository.dart'; // Importa TaskRepository
import '../api/service/task_service.dart'; // Importa TaskService
import '../views/task_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TasksScreen(),
    );
  }
}
  
class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TaskRepository _taskRepository = TaskRepository(); // Instancia del repositorio
  final ScrollController _scrollController = ScrollController();
  final TaskService _taskService = TaskService(); // Instancia del servicio
  List<Task> tasks = [];
  bool isLoading = false; // Indicador de carga

  @override
  void initState() {
    super.initState();
    _loadInitialTasks();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
      _loadMoreTasks();
    }
  }

void _loadMoreTasks() async {
  setState(() {
    isLoading = true; // Activa el indicador de carga
  });

  final newTasks = await _taskService.generarTareas(5, tasks.length); // Usa TaskService para generar tareas

  setState(() {
    tasks.addAll(newTasks);
    isLoading = false; // Desactiva el indicador de carga
  });
}

  void _addTask(Task newTask) async {
  await _taskService.addTask(newTask); // Delega la lógica a TaskService
  setState(() {
    tasks = _taskService.getAllTasks(); // Sincroniza la lista local con el repositorio
  });
}

  void _updateTask(int index, Task updatedTask) async {
    await _taskRepository.updateTask(index, updatedTask); // Actualiza la tarea en el repositorio
    setState(() {
      tasks[index] = updatedTask;
    });
  }

  void _deleteTask(int index) async {
    await _taskRepository.deleteTaskByIndex(index); // Elimina la tarea del repositorio
    setState(() {
      tasks.removeAt(index);
    });
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(AppConstants.TITLE_APPBAR),
      centerTitle: true,
    ),
    body: Column(
      children: [
        Expanded(
          child: tasks.isEmpty
              ? Center(
                  child: Text(AppConstants.EMPTY_LIST),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: tasks.length + (isLoading ? 1 : 0), // Agrega un elemento extra si está cargando
                  itemBuilder: (context, index) {
                    if (index == tasks.length && isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(), // Indicador de carga
                        ),
                      );
                    }
                    final task = tasks[index];
                    // Llama a construirTarjetaDeportiva con todos los parámetros requeridos
                    return construirTarjetaDeportiva(
                      context, // Pasa el contexto
                      task,    // Pasa la tarea actual
                      index,   // Pasa el índice actual
                      // Callback para editar la tarea
                      () {
                        showEditTaskModal(
                          context,
                          task,
                          (updatedTask) {
                            setState(() {
                              tasks[index] = updatedTask; // Actualiza la tarea en la lista
                            });
                          },
                          // Callback para eliminar la tarea desde la tarjeta
  () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                tasks.removeAt(index); // Elimina la tarea de la lista
              });
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  },
                        );
                      },
                      // Callback para eliminar la tarea
                      () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Eliminar tarea'),
                            content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteTask(index); // Llama a la función para eliminar la tarea
                                },
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => showAddTaskModal(
        context,
        (newTask) => _addTask(newTask),
      ),
      child: const Icon(Icons.add),
    ),
  );
}
void _loadInitialTasks() async {
  // Obtiene las tareas iniciales desde el repositorio
  final initialTasks = _taskRepository.getTasks();

  // Actualiza el estado de la pantalla con las tareas iniciales
  setState(() {
    tasks = initialTasks;
  });
}
}