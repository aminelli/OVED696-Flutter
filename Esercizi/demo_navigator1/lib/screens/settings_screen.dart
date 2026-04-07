/// Schermata delle impostazioni dell'applicazione.
/// 
/// Contiene:
/// - Preferenze utente (tema, notifiche)
/// - Informazioni sull'app
/// - Azioni pericolose (reset dati, cancella tutti i task)
/// - Informazioni sulla navigazione Navigator 1.0
/// 
/// Dimostra l'uso di Navigator.pushAndRemoveUntil per il reset dell'app.

import 'package:flutter/material.dart';
import '../routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Impostazioni simulate (in un'app reale usare SharedPreferences o simili)
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _showCompletedTasks = true;

  /// Mostra dialog informativo sull'app.
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Task Manager',
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(size: 48),
      children: [
        const SizedBox(height: 16),
        const Text(
          'Applicazione demo per dimostrare l\'utilizzo di Navigator 1.0 in Flutter.',
        ),
        const SizedBox(height: 8),
        const Text(
          'Implementa un sistema completo di gestione task con navigazione, '
          'routing e passaggio dati tra schermate.',
        ),
      ],
    );
  }

  /// Mostra dialog con informazioni su Navigator 1.0.
  void _showNavigatorInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.navigation, color: Colors.blue),
            SizedBox(width: 8),
            Text('Navigator 1.0'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Questa app utilizza Navigator 1.0 con le seguenti funzionalità:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildNavigatorFeature(
                'Named Routes',
                'Tutte le route sono definite con nomi costanti per consistenza',
              ),
              _buildNavigatorFeature(
                'onGenerateRoute',
                'Gestione centralizzata delle route con validazione argomenti',
              ),
              _buildNavigatorFeature(
                'Push & Pop',
                'Navigazione standard con passaggio e ritorno dati',
              ),
              _buildNavigatorFeature(
                'PushReplacement',
                'Sostituzione della route corrente (usato nel form)',
              ),
              _buildNavigatorFeature(
                'WillPopScope',
                'Controllo del back button con conferme',
              ),
              _buildNavigatorFeature(
                'Route Arguments',
                'Classi tipizzate per passaggio parametri sicuro',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  /// Widget helper per mostrare una funzionalità di Navigator.
  Widget _buildNavigatorFeature(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra conferma per eliminare tutti i task.
  void _confirmDeleteAllTasks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Attenzione'),
          ],
        ),
        content: const Text(
          'Sei sicuro di voler eliminare TUTTI i task? '
          'Questa azione non può essere annullata.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllTasks();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Elimina Tutto'),
          ),
        ],
      ),
    );
  }

  /// Elimina tutti i task e torna alla home.
  void _deleteAllTasks() {
    // In un'app reale, qui elimineremmo tutti i task dal database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tutti i task sono stati eliminati'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );

    // Torna alla home rimuovendo tutte le route precedenti
    // Questo è un esempio di pushAndRemoveUntil
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false, // Rimuove tutte le route precedenti
    );
  }

  /// Reset completo dell'applicazione.
  void _resetApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.restart_alt, color: Colors.orange),
            SizedBox(width: 8),
            Text('Reset App'),
          ],
        ),
        content: const Text(
          'Vuoi resettare l\'applicazione alle impostazioni iniziali? '
          'Tutti i dati e le preferenze saranno cancellati.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performReset();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  /// Esegue il reset dell'app.
  void _performReset() {
    // Reset delle impostazioni
    setState(() {
      _notificationsEnabled = true;
      _darkModeEnabled = false;
      _showCompletedTasks = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('App resettata con successo'),
        backgroundColor: Colors.green,
      ),
    );

    // Torna alla home pulendo lo stack
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
      ),
      body: ListView(
        children: [
          // Sezione Preferenze
          const _SectionHeader(title: 'Preferenze'),
          SwitchListTile(
            title: const Text('Notifiche'),
            subtitle: const Text('Ricevi notifiche per i task importanti'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: const Text('Tema Scuro'),
            subtitle: const Text('Attiva il tema scuro dell\'app'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() => _darkModeEnabled = value);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funzionalità in arrivo nella prossima versione'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: const Text('Mostra Task Completati'),
            subtitle: const Text('Visualizza i task completati nella home'),
            value: _showCompletedTasks,
            onChanged: (value) {
              setState(() => _showCompletedTasks = value);
            },
            secondary: const Icon(Icons.check_circle_outline),
          ),

          const Divider(),

          // Sezione Informazioni
          const _SectionHeader(title: 'Informazioni'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Informazioni App'),
            subtitle: const Text('Versione, licenza e credits'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showAboutDialog,
          ),
          ListTile(
            leading: const Icon(Icons.navigation),
            title: const Text('Navigator 1.0'),
            subtitle: const Text('Scopri le funzionalità implementate'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showNavigatorInfo,
          ),

          const Divider(),

          // Sezione Dati
          const _SectionHeader(title: 'Gestione Dati'),
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: const Text(
              'Elimina Tutti i Task',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text('Cancella permanentemente tutti i task'),
            onTap: _confirmDeleteAllTasks,
          ),
          ListTile(
            leading: const Icon(Icons.restart_alt, color: Colors.orange),
            title: const Text(
              'Reset Applicazione',
              style: TextStyle(color: Colors.orange),
            ),
            subtitle: const Text('Ripristina impostazioni iniziali'),
            onTap: _resetApp,
          ),

          const SizedBox(height: 24),

          // Footer con info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const FlutterLogo(size: 48),
                const SizedBox(height: 8),
                Text(
                  'Task Manager v1.0.0',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Powered by Flutter & Navigator 1.0',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget helper per le intestazioni delle sezioni.
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
