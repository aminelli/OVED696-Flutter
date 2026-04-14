/// File: add_task_dialog.dart
/// 
/// Dialog per l'aggiunta di un nuovo task.
/// Permette di inserire titolo e descrizione opzionale.

import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  final void Function(String title, String? description) onAdd;

  const AddTaskDialog({super.key, required this.onAdd});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo titolo
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter task title',
                prefixIcon: Icon(Icons.title),
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                if (value.trim().length < 3) {
                  return 'Title must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Campo descrizione (opzionale)
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Enter task description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _handleAdd() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      
      widget.onAdd(
        title,
        description.isEmpty ? null : description,
      );
    }
  }
}
