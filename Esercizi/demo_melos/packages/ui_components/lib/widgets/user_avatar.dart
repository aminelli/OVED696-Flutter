import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Avatar circolare che visualizza l'immagine o le iniziali di un utente.
///
/// Se l'utente ha un avatarUrl, carica l'immagine.
/// Altrimenti mostra le iniziali del nome su uno sfondo colorato.
class UserAvatar extends StatelessWidget {
  /// Crea un UserAvatar.
  const UserAvatar({
    super.key,
    required this.user,
    this.radius = 20,
    this.showBorder = false,
  });

  /// Utente di cui visualizzare l'avatar.
  final User user;

  /// Raggio dell'avatar in pixel.
  final double radius;

  /// Se true, mostra un bordo bianco attorno all'avatar.
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Genera un colore basato sull'ID utente per consistenza
    final colorIndex = user.id.hashCode.abs() % Colors.primaries.length;
    final backgroundColor = Colors.primaries[colorIndex];

    Widget avatarContent;

    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      // Mostra l'immagine dell'avatar
      avatarContent = CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(user.avatarUrl!),
        backgroundColor: backgroundColor,
        onBackgroundImageError: (_, __) {
          // Fallback in caso di errore nel caricamento
        },
      );
    } else {
      // Mostra le iniziali
      avatarContent = CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: Text(
          user.initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.8,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (showBorder) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.surface,
            width: 2,
          ),
        ),
        child: avatarContent,
      );
    }

    return avatarContent;
  }
}

/// Widget che mostra l'avatar con il nome dell'utente.
///
/// Combina l'avatar con il nome in una riga, utile per headers
/// e liste di utenti.
class UserAvatarWithName extends StatelessWidget {
  /// Crea un UserAvatarWithName.
  const UserAvatarWithName({
    super.key,
    required this.user,
    this.showEmail = false,
    this.avatarRadius = 20,
  });

  /// Utente da visualizzare.
  final User user;

  /// Se true, mostra anche l'email sotto il nome.
  final bool showEmail;

  /// Raggio dell'avatar.
  final double avatarRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        UserAvatar(
          user: user,
          radius: avatarRadius,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (showEmail) ...[
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
