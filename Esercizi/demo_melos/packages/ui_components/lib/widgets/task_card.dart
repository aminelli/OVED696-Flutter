import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Card che visualizza un task con checkbox e informazioni.
///
/// Mostra:
/// - Checkbox per completare/decompletare il task
/// - Titolo del task
/// - Descrizione (se presente)
/// - Data di creazione formattata
/// - Icona per accedere ai dettagli
class TaskCard extends StatelessWidget {
  /// Crea una TaskCard.
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
  });

  /// Task da visualizzare.
  final Task task;

  /// Callback quando la card viene tappata.
  final VoidCallback onTap;

  /// Callback quando il checkbox viene tappato.
  final ValueChanged<bool> onToggleComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = task.isCompleted
        ? TextStyle(
            decoration: TextDecoration.lineThrough,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          )
        : null;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) => onToggleComplete(value ?? false),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),

              // Contenuto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titolo
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                          )
                          .merge(textStyle),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Descrizione (se presente)
                    if (task.description != null &&
                        task.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        style: theme.textTheme.bodyMedium?.merge(textStyle),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 8),

                    // Data
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormatter.formatRelativeDate(task.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        if (task.isCompleted && task.completedAt != null) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Completato ${DateFormatter.formatRelativeDate(task.completedAt!)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Icona dettaglio
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
