import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../constants.dart';
import '../helpers/task_card_helper.dart';
import '../components/task_modals.dart';
import '../data/task_repository.dart'; // Importa TaskRepository

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

  void _loadInitialTasks() async {
    final initialTasks = await _taskRepository.getTasks(); // Obtiene las tareas iniciales del repositorio
    setState(() {
      tasks = initialTasks;
    });
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

    await Future.delayed(const Duration(milliseconds: 500)); // Simula una operación asincrónica

    final newTasks = List.generate(
      5,
      (index) {
        final taskIndex = tasks.length + index + 1; // Calcula el índice global de la tarea
        return Task(
          title: 'Tarea $taskIndex',
          description: 'Random description',
          type: taskIndex % 2 == 0 ? 'urgente' : 'normal',
          fechaLimite: DateTime.now().add(Duration(days: taskIndex)),
          pasos:['Paso 1: Planificar Tarea $taskIndex',
                'Paso 2: Ejecutar Tarea $taskIndex',
                'Paso 3: Revisar Tarea $taskIndex',
          
          ] // Simula una fecha límite
           // Par: urgente, Impar: normal
        );
        
      },
    );

    setState(() {
      tasks.addAll(newTasks);
      isLoading = false; // Desactiva el indicador de carga
    });
  }

  void _addTask(Task newTask) async {
    await _taskRepository.addTask(newTask); // Agrega la tarea al repositorio
    setState(() {
      tasks.add(newTask);
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
                      return GestureDetector(
                        onTap: () => showEditTaskModal(
                          context,
                          tasks[index],
                          (updatedTask) => _updateTask(index, updatedTask),
                          () => _deleteTask(index),
                        ),
                        child: buildTaskCard(tasks[index]),
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
        child: Icon(Icons.add),
      ),
    );
  }
}