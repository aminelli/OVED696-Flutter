/// File di configurazione centrale per tutte le route dell'applicazione.
/// 
/// Questo file gestisce:
/// - Definizione di tutte le named routes
/// - Generazione delle route con onGenerateRoute
/// - Gestione delle route sconosciute
/// - Passaggio sicuro degli argomenti tra schermate

import 'package:flutter/material.dart';
import 'models/route_arguments.dart';
import 'screens/home_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/task_form_screen.dart';
import 'screens/settings_screen.dart';

/// Classe che contiene tutte le costanti delle route dell'applicazione.
/// 
/// Utilizzare queste costanti invece di stringhe hardcoded assicura
/// consistenza e riduce gli errori di battitura.
class AppRoutes {
  // Previene l'istanziazione della classe
  AppRoutes._();

  /// Route per la schermata principale (home).
  /// Non richiede argomenti.
  static const String home = '/';

  /// Route per la schermata di dettaglio di un task.
  /// Richiede argomenti: TaskDetailArguments(taskId: String)
  static const String taskDetail = '/task-detail';

  /// Route per la schermata del form di creazione/modifica task.
  /// Richiede argomenti: TaskFormArguments(task: Task?, isEditing: bool)
  static const String taskForm = '/task-form';

  /// Route per la schermata delle impostazioni.
  /// Non richiede argomenti.
  static const String settings = '/settings';
}

/// Generatore centrale di route per l'applicazione.
/// 
/// Gestisce la creazione di tutte le route dell'app e il passaggio
/// sicuro degli argomenti. Utilizza il pattern [RouteSettings] per
/// accedere al nome della route e agli argomenti passati.
/// 
/// Esempio di utilizzo:
/// ```dart
/// Navigator.pushNamed(
///   context,
///   AppRoutes.taskDetail,
///   arguments: TaskDetailArguments(taskId: '123'),
/// );
/// ```
class RouteGenerator {
  // Previene l'istanziazione della classe
  RouteGenerator._();

  /// Genera una route basandosi sul nome e sugli argomenti forniti.
  /// 
  /// Restituisce null se la route non è riconosciuta, permettendo
  /// a [onUnknownRoute] di gestire il caso.
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Recupera gli argomenti passati alla route (se presenti)
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case AppRoutes.taskDetail:
        // Verifica che gli argomenti siano del tipo corretto
        if (args is TaskDetailArguments) {
          return MaterialPageRoute(
            builder: (_) => TaskDetailScreen(
              taskId: args.taskId,
            ),
            settings: settings,
          );
        }
        // Se gli argomenti non sono corretti, restituisce una route di errore
        return _errorRoute(
          'Argomenti non validi per taskDetail. Richiesto: TaskDetailArguments',
        );

      case AppRoutes.taskForm:
        // TaskFormArguments può essere null (per creazione) o presente (per modifica)
        if (args == null || args is TaskFormArguments) {
          return MaterialPageRoute(
            builder: (_) => TaskFormScreen(
              arguments: args as TaskFormArguments?,
            ),
            settings: settings,
          );
        }
        return _errorRoute(
          'Argomenti non validi per taskForm. Richiesto: TaskFormArguments',
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );

      default:
        // Route non riconosciuta, verrà gestita da onUnknownRoute
        return null;
    }
  }

  /// Gestisce le route sconosciute o non trovate.
  /// 
  /// Mostra una schermata di errore con un messaggio appropriato
  /// e un pulsante per tornare alla home.
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Errore'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Route non trovata',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'La route "${settings.name}" non esiste.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Torna alla home rimuovendo tutte le route precedenti
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Torna alla Home'),
                ),
              ],
            ),
          ),
        ),
      ),
      settings: settings,
    );
  }

  /// Crea una route di errore per argomenti non validi.
  /// 
  /// Utilizzata internamente quando gli argomenti passati a una route
  /// non corrispondono al tipo atteso.
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Errore Argomenti'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 64,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Errore negli argomenti',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Indietro'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
