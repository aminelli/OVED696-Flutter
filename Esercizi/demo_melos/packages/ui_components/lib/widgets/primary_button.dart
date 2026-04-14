import 'package:flutter/material.dart';

/// Button primario dell'applicazione con stile consistente.
///
/// Usa il tema dell'app per colori e dimensioni.
/// Supporta stati:
/// - Normale: cliccabile
/// - Loading: mostra un indicatore di caricamento
/// - Disabled: non cliccabile (quando onPressed è null)
class PrimaryButton extends StatelessWidget {
  /// Crea un PrimaryButton.
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.icon,
  });

  /// Callback quando il button viene premuto.
  /// Se null, il button è disabilitato.
  final VoidCallback? onPressed;

  /// Testo mostrato nel button.
  final String label;

  /// Se true, mostra un indicatore di caricamento al posto del testo.
  final bool isLoading;

  /// Icona opzionale da mostrare prima del testo.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Button secondario dell'applicazione con bordo.
///
/// Versione outlined del button primario.
class SecondaryButton extends StatelessWidget {
  /// Crea un SecondaryButton.
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  /// Callback quando il button viene premuto.
  final VoidCallback? onPressed;

  /// Testo mostrato nel button.
  final String label;

  /// Icona opzionale da mostrare prima del testo.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
