import 'package:flutter/material.dart';
import 'package:afranco/domain/task.dart';
import 'package:uuid/uuid.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;
  final String? usuario;
  const TaskForm({super.key, this.task, required this.onSave,this.usuario});

  @override
  TaskFormState createState() => TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _type;
  late DateTime _fecha;

  // Lista de tipos de tarea disponibles
  static const List<String> taskTypes = ['normal', 'urgente', 'importante'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.titulo ?? '');
    _descriptionController = TextEditingController(text: widget.task?.descripcion ?? '');
    _type = widget.task?.tipo ?? 'normal';
    _fecha = widget.task?.fechaLimite ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa un título';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 3,
            validator: (value) {
              // La descripción es opcional, pero si se ingresa debe tener al menos 3 caracteres
              if (value != null && value.trim().isNotEmpty && value.trim().length < 3) {
                return 'La descripción debe tener al menos 3 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _type,
            items: taskTypes
                .map((tipo) => DropdownMenuItem(
                      value: tipo,
                      child: Row(
                        children: [
                          Icon(
                            _getIconForType(tipo),
                            color: _getColorForType(tipo),
                          ),
                          const SizedBox(width: 8),
                          Text(tipo.toUpperCase()),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _type = value!),
            decoration: const InputDecoration(
              labelText: 'Tipo',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _fecha,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                locale: const Locale('es', 'ES'),
              );
              if (selectedDate != null) {
                setState(() => _fecha = selectedDate);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Fecha límite',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              child: Text(
                '${_fecha.day.toString().padLeft(2, '0')}/${_fecha.month.toString().padLeft(2, '0')}/${_fecha.year}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newTask = Task(
                    id: widget.task?.id ?? const Uuid().v4(),
                    usuario: widget.task?.usuario ?? 'usuario_actual', // Ajusta según tu lógica de usuario
                    titulo: _titleController.text.trim(),
                    descripcion: _descriptionController.text.trim().isEmpty 
                        ? null 
                        : _descriptionController.text.trim(),
                    tipo: _type,
                    fechaLimite: _fecha,
                    fecha: widget.task?.fecha ?? DateTime.now(),
                  );
                  widget.onSave(newTask);
                }
              },
              icon: Icon(widget.task == null ? Icons.add : Icons.save),
              label: Text(widget.task == null ? 'Crear Tarea' : 'Actualizar Tarea'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'urgente':
        return Icons.warning;
      case 'importante':
        return Icons.star;
      default:
        return Icons.task;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'urgente':
        return Colors.red;
      case 'importante':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}