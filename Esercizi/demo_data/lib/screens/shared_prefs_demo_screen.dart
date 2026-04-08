import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

/// Schermata demo per SharedPreferences.
/// 
/// Mostra esempi pratici di utilizzo:
/// - Salvataggio impostazioni tema (dark/light)
/// - Nome utente
/// - Lingua preferita
/// - Flag "mostra tutorial"
/// - Contatore lanci app
class SharedPrefsDemoScreen extends StatefulWidget {
  const SharedPrefsDemoScreen({super.key});

  @override
  State<SharedPrefsDemoScreen> createState() => _SharedPrefsDemoScreenState();
}

class _SharedPrefsDemoScreenState extends State<SharedPrefsDemoScreen> {
  final PreferencesService _prefsService = PreferencesService();

  // Valori UI
  String _userName = 'Guest';
  String _language = 'en';
  bool _showTutorial = true;
  int _launchCount = 0;
  String _themeMode = 'system';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Carica tutte le preferenze salvate
  Future<void> _loadPreferences() async {
    setState(() => _isLoading = true);
    
    try {
      await _prefsService.init();
      
      final settings = await _prefsService.loadUserSettings();
      final themeMode = await _prefsService.getThemeMode();

      setState(() {
        _userName = settings['user_name'] ?? 'Guest';
        _language = settings['language'] ?? 'en';
        _showTutorial = settings['show_tutorial'] ?? true;
        _launchCount = settings['app_launch_count'] ?? 0;
        _themeMode = themeMode;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error loading preferences: $e');
    }
  }

  /// Salva il nome utente
  Future<void> _saveUserName(String name) async {
    try {
      await _prefsService.setString('user_name', name);
      setState(() => _userName = name);
      _showSuccess('Username saved!');
    } catch (e) {
      _showError('Error saving username: $e');
    }
  }

  /// Cambia la lingua
  Future<void> _changeLanguage(String lang) async {
    try {
      await _prefsService.setString('language', lang);
      setState(() => _language = lang);
      _showSuccess('Language changed!');
    } catch (e) {
      _showError('Error changing language: $e');
    }
  }

  /// Toggle del tutorial
  Future<void> _toggleTutorial(bool value) async {
    try {
      await _prefsService.setBool('show_tutorial', value);
      setState(() => _showTutorial = value);
      _showSuccess('Tutorial setting updated!');
    } catch (e) {
      _showError('Error updating tutorial setting: $e');
    }
  }

  /// Incrementa il contatore
  Future<void> _incrementLaunchCount() async {
    try {
      final newCount = await _prefsService.incrementCounter('app_launch_count');
      setState(() => _launchCount = newCount);
      _showSuccess('Launch count: $newCount');
    } catch (e) {
      _showError('Error incrementing counter: $e');
    }
  }

  /// Cambia il tema
  Future<void> _changeTheme(String mode) async {
    try {
      await _prefsService.setThemeMode(mode);
      setState(() => _themeMode = mode);
      _showSuccess('Theme changed to $mode!');
    } catch (e) {
      _showError('Error changing theme: $e');
    }
  }

  /// Pulisce tutte le preferenze
  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Preferences'),
        content: const Text(
          'Are you sure you want to clear all preferences? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _prefsService.clearAll();
        _showSuccess('All preferences cleared!');
        await _loadPreferences();
      } catch (e) {
        _showError('Error clearing preferences: $e');
      }
    }
  }

  /// Mostra tutte le chiavi salvate
  Future<void> _showAllKeys() async {
    try {
      final keys = await _prefsService.getAllKeys();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('All Stored Keys'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total keys: ${keys.length}'),
                const Divider(),
                ...keys.map((key) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('• $key'),
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showError('Error loading keys: $e');
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _showAllKeys,
            tooltip: 'Show All Keys',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPreferences,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User Name Card
                  _buildCard(
                    title: 'User Name',
                    icon: Icons.person,
                    color: Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current: $_userName',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton (
                          onPressed: () async {
                            final controller =
                                TextEditingController(text: _userName);
                            final result = await showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Change Username'),
                                content: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.pop(context, controller.text),
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            );
                            if (result != null && result.isNotEmpty) {
                              _saveUserName(result);
                            }
                          },
                          child: const Text('Change Username'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Language Card
                  _buildCard(
                    title: 'Language',
                    icon: Icons.language,
                    color: Colors.orange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current: ${_getLanguageName(_language)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            ChoiceChip(
                              label: const Text('English'),
                              selected: _language == 'en',
                              onSelected: (selected) {
                                if (selected) _changeLanguage('en');
                              },
                            ),
                            ChoiceChip(
                              label: const Text('Italiano'),
                              selected: _language == 'it',
                              onSelected: (selected) {
                                if (selected) _changeLanguage('it');
                              },
                            ),
                            ChoiceChip(
                              label: const Text('Español'),
                              selected: _language == 'es',
                              onSelected: (selected) {
                                if (selected) _changeLanguage('es');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Theme Mode Card
                  _buildCard(
                    title: 'Theme Mode',
                    icon: Icons.brightness_6,
                    color: Colors.purple,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current: ${_themeMode.toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            ChoiceChip(
                              label: const Text('System'),
                              selected: _themeMode == 'system',
                              onSelected: (selected) {
                                if (selected) _changeTheme('system');
                              },
                            ),
                            ChoiceChip(
                              label: const Text('Light'),
                              selected: _themeMode == 'light',
                              onSelected: (selected) {
                                if (selected) _changeTheme('light');
                              },
                            ),
                            ChoiceChip(
                              label: const Text('Dark'),
                              selected: _themeMode == 'dark',
                              onSelected: (selected) {
                                if (selected) _changeTheme('dark');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tutorial Card
                  _buildCard(
                    title: 'Show Tutorial',
                    icon: Icons.help_outline,
                    color: Colors.green,
                    child: SwitchListTile(
                      value: _showTutorial,
                      onChanged: _toggleTutorial,
                      title: const Text('Show tutorial on startup'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Launch Counter Card
                  _buildCard(
                    title: 'App Launch Counter',
                    icon: Icons.rocket_launch,
                    color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Launches: $_launchCount',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _incrementLaunchCount,
                          icon: const Icon(Icons.add),
                          label: const Text('Increment'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Clear All Button
                  OutlinedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    label: const Text(
                      'Clear All Preferences',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'it':
        return 'Italiano';
      case 'es':
        return 'Español';
      default:
        return code;
    }
  }
}
