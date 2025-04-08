import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../data/task_repository.dart';
import '../constants.dart';

void main() {
  runApp(const ListaEstaticaApp());
}

class ListaEstaticaApp extends StatelessWidget {
  const ListaEstaticaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Tareas Estáticas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StaticListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StaticListScreen extends StatefulWidget {
  const StaticListScreen({super.key});

  @override
  State<StaticListScreen> createState() => _StaticListScreenState();
}

class _StaticListScreenState extends State<StaticListScreen> {
  final TaskRepository _repository = TaskRepository();
  int _taskCounter = 0;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _repository.getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _toggleTask(Task task) async {
    await _repository.toggleTaskCompletion(task.id);
    _loadTasks();
  }


  
  void _addTask() async {
    _taskCounter++; // Incrementa antes de usar
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Tarea $_taskCounter', // Usa el contador
    );
    await _repository.addTask(newTask);
    _loadTasks();
  }
  void _deleteTask(String id) async {
    await _repository.deleteTask(id);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TITLE_APPBAR),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(child: Text(EMPTY_LIST))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: Key(task.id),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) => _deleteTask(task.id),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) => _toggleTask(task),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTask(task.id),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}