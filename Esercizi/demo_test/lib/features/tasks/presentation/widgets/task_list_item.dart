/// File: task_list_item.dart
/// 
/// Widget per la visualizzazione di un singolo task nella lista.
/// Mostra titolo, descrizione, stato e azioni.

import 'package:flutter/material.dart';
import 'package:demo_test/features/tasks/domain/entities/task.dart';
import 'package:intl/intl.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    this.onTap,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        // Checkbox per completamento
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle?.call(),
        ),
        
        // Titolo e descrizione
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted 
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  task.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              'Created: ${dateFormat.format(task.createdAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (task.completedAt != null)
              Text(
                'Completed: ${dateFormat.format(task.completedAt!)}',
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
          ],
        ),
        
        // Azioni
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              onDelete?.call();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
        
        onTap: onTap,
      ),
    );
  }
}
