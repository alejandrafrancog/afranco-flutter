import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../constants.dart';
import '../components/task_modals.dart';
import '../data/task_repository.dart'; // Importa TaskRepository
import '../api/service/task_service.dart'; // Importa TaskService
import '../helpers/common_widgets_helper.dart'; 
import '../components/task_image.dart';
import 'task_detail_screen.dart';

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

void _addTask(Task newTask) async {
  // Asegúrate de que los valores no sean nulos antes de pasarlos
  final title = newTask.title; // Proveer un valor predeterminado
  final type = newTask.type ?? 'normal'; // Proveer un valor predeterminado
  final fechaLimite = newTask.fechaLimite; // Proveer un valor predeterminado

  await _taskService.addTask(title, type, fechaLimite);
  await _loadTasks(); // Recarga las tareas después de agregar una nueva
}
Future<void> _loadTasks() async {
  final loadedTasks = await _taskService.getAllTasks(); // Obtiene las tareas desde el servicio
  setState(() {
    tasks = loadedTasks; // Actualiza la lista local de tareas
  });
}
void _deleteTask(int index) async {
  final taskToDelete = tasks[index];
  
  await _taskRepository.deleteTaskById(taskToDelete.id); // <<< Elimina por ID
  final updatedTasks = await _taskService.getAllTasks();

  setState(() => tasks = updatedTasks);
  
  _showDeleteSnackbar(context, taskToDelete, index);
}

  // En _TasksScreenState (tasks.dart)

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('${AppConstants.titleAppBar} - Total: ${tasks.length}'),
         // Título dinámico
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: tasks.isEmpty
                ? Center(child: Text(AppConstants.EMPTY_LIST))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: tasks.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= tasks.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final task = tasks[index];
                      return _buildTaskItem(task, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskModal(context, _addTask),
        child: const Icon(Icons.add),
      ),
    );
  }


Widget _buildTaskItem(Task task, int index) {
  return Dismissible(
    key: Key(task.id),
    direction: DismissDirection.endToStart,
    background: Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    onDismissed: (direction) {
      final deletedTask = tasks[index];
      _deleteTask(index);
      _showDeleteSnackbar(context, deletedTask, index);
    },
    child: GestureDetector( // <--- AQUÍ SE AGREGA
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskDetailScreen(
            task: task,
            indice: index,
            onNeedMoreTasks: _loadMoreTasks, // <-- Callback correcto
          ),
        ),
      ),
      child: Container( // <--- Este es el Container original
        decoration: CommonWidgetsHelper.buildRoundedBorder(),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            TaskImage(
              randomIndex: index, 
              height: 150,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: CommonWidgetsHelper.buildBoldTitle(task.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidgetsHelper.buildSpacing(),
                  CommonWidgetsHelper.buildInfoLines(
                    line1: 'Tipo: ${task.type}',
                    line2: task.pasos.isNotEmpty 
                        ? 'Primer paso: ${task.pasos[0]}' 
                        : 'Sin pasos',
                  ),
                  CommonWidgetsHelper.buildSpacing(),
                  CommonWidgetsHelper.buildBoldFooter(
                    'Fecha: ${_formatDate(task.fechaLimite)}'
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  void _showDeleteSnackbar(BuildContext context, Task task, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarea eliminada: ${task.title}'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () => setState(() => tasks.insert(index, task)),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    return date != null
        ? '${date.day}/${date.month}/${date.year}'
        : 'Sin fecha';
  }

  void _loadInitialTasks() async {
  setState(() => isLoading = true);
  
  final initialTasks = await _taskService.generarTareas(5, 0);
  // Añadir cada tarea al repositorio
  for (final task in initialTasks) {
    await _taskRepository.addTask(task); // Necesitarás un método en TaskService para esto
  }
  
  await _loadTasks(); // Ahora carga desde el repositorio
  
  setState(() => isLoading = false);
}
Future<void> _loadMoreTasks() async {
  if (isLoading) return;

  setState(() => isLoading = true);
  
  // Usa el TaskService para cargar más tareas
  final nuevasTareas = await TaskService().generarTareas(5, tasks.length);
  
  setState(() {
    tasks.addAll(nuevasTareas);
    isLoading = false;
  });
}

  Future<void> _showEditTaskModal(Task task, int index) async {
    await showEditTaskModal(
      context,
      task,
      (updatedTask) {
        setState(() {
          tasks[index] = updatedTask;
        });
      },
      () => _deleteTask(index),
    );
  }
}