/// Widget riutilizzabile per visualizzare un singolo task in una lista.
/// 
/// Mostra:
/// - Checkbox per lo stato di completamento
/// - Titolo del task
/// - Badge con la priorità
/// - Azione tap per navigare ai dettagli

import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  /// Il task da visualizzare
  final Task task;

  /// Callback chiamata quando lo stato di completamento cambia
  final Function(bool?) onToggleComplete;

  /// Callback chiamata quando si tap sulla card
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Checkbox per il completamento
              Checkbox(
                value: task.isCompleted,
                onChanged: onToggleComplete,
                activeColor: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              // Contenuto del task
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titolo del task
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? Colors.grey
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      // Descrizione breve
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Badge priorità
              _PriorityBadge(priority: task.priority),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget interno per visualizzare il badge della priorità.
class _PriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    IconData icon;

    switch (priority) {
      case TaskPriority.low:
        badgeColor = Colors.green;
        icon = Icons.arrow_downward;
        break;
      case TaskPriority.medium:
        badgeColor = Colors.orange;
        icon = Icons.remove;
        break;
      case TaskPriority.high:
        badgeColor = Colors.red;
        icon = Icons.arrow_upward;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            priority.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}
