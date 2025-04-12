import 'package:flutter/material.dart'; // Para los widgets de Flutter como Form, TextFormField, etc.
import '../domain/task.dart'; // Para el modelo de datos Task.
import 'package:uuid/uuid.dart';
class TaskForm extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskForm({Key? key, this.task, required this.onSave}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _type;
  late DateTime _fecha;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _type = widget.task?.type ?? 'normal';
    _fecha = widget.task?.fechaLimite ?? DateTime.now().add(Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Título'),
            validator: (value) => value!.isEmpty ? 'Ingresa un título' : null,
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          DropdownButtonFormField<String>(
            value: _type,
            items: Task.taskTypes
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.toUpperCase()),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _type = value!),
            decoration: const InputDecoration(labelText: 'Tipo'),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _fecha,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                setState(() => _fecha = selectedDate);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Fecha límite'),
              child: Text('${_fecha.day}/${_fecha.month}/${_fecha.year}'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: widget.task?.id ?? const Uuid().v4(), // <<< Genera ID solo para nuevas tareas
        title: _titleController.text,
        description: _descriptionController.text,
        type: _type,
        fechaLimite: _fecha,
        pasos: widget.task?.pasos ?? [],
      );
      widget.onSave(newTask);
    }
  },
  child: const Text('Guardar'),
),
        ],
      ),
    );
  }
}