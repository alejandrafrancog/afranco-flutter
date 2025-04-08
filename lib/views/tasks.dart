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
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreTasks();
    }
  }

void _loadMoreTasks() async {
  final newTasks = List.generate(
    5,
    (index) {
      final taskIndex = tasks.length + index + 1; // Calcula el índice global de la tarea
      return Task(
        title: 'Tarea $taskIndex',
        type: taskIndex % 2 == 0 ? 'urgente' : 'normal', // Par: urgente, Impar: normal
      );
    },
  );
  await Future.delayed(const Duration(milliseconds: 300)); // Simula una operación asincrónica
  setState(() {
    tasks.addAll(newTasks);
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
      body: tasks.isEmpty
          ? Center(
              child: Text(AppConstants.EMPTY_LIST),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => showEditTaskModal(
                    context,
                    tasks[index],
                    (updatedTask) => _updateTask(index, updatedTask), // Usa el método para actualizar
                    () => _deleteTask(index), // Usa el método para eliminar
                  ),
                  child: buildTaskCard(tasks[index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskModal(
          context,
          (newTask) => _addTask(newTask), // Usa el método para agregar
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
/*import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../constants.dart';
import '../helpers/task_card_helper.dart';
import '../components/task_modals.dart';

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
  List<Task> tasks = [];
  final ScrollController _scrollController = ScrollController();

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

  void _loadInitialTasks() {
    setState(() {
      tasks = List.generate(
        10,
        (index) => Task(title: 'Tarea ${index + 1}', type: 'normal'),
      );
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreTasks();
    }
  }

  void _loadMoreTasks() {
    setState(() {
      final newTasks = List.generate(
        5,
        (index) => Task(title: 'Tarea ${tasks.length + index + 1}', type: 'normal'),
      );
      tasks.addAll(newTasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.TITLE_APPBAR),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(AppConstants.EMPTY_LIST),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => showEditTaskModal(
                    context,
                    tasks[index],
                    (updatedTask) {
                      setState(() {
                        tasks[index] = updatedTask;
                      });
                    },
                    () {
                      setState(() {
                        tasks.removeAt(index);
                      });
                    },
                  ),
                  child: buildTaskCard(tasks[index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskModal(
          context,
          (newTask) {
            setState(() {
              tasks.add(newTask);
            });
          },
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}*/