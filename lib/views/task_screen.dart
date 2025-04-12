import 'package:flutter/material.dart';
import '../data/task_repository.dart';
import '../domain/task.dart';
import '../constants.dart';
import '../components/task_card.dart'; // Importa la clase TaskCard
import 'package:uuid/uuid.dart'; // Importa la librería uuid
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskRepository _taskRepository = TaskRepository();
  final ScrollController _scrollController = ScrollController();
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _taskRepository.getTasks(); // Obtiene las tareas iniciales
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        (index){
          final taskIndex = _tasks.length + index +1;
          return Task(
            id: const Uuid().v4(),
            title: 'Tarea $taskIndex',
            description: "Default description",
            type: 'normal',
            fechaLimite: DateTime.now().add(Duration(days: 7)), // Simula una fecha límite
            pasos: ['Paso 1', 'Paso 2', 'Paso 3'], // Simula pasos
          );
        }
      );
      _tasks.addAll(newTasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.TITLE_APPBAR),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                AppConstants.EMPTY_LIST,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskCard(task: task); // Usa la clase TaskCard
              },
            ),
    );
  }
}
