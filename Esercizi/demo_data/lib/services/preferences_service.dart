import 'package:shared_preferences/shared_preferences.dart';

/// Service per gestire le preferenze dell'applicazione usando SharedPreferences.
/// 
/// Permette di:
/// - Salvare preferenze semplici (String, int, bool, double, List<String>)
/// - Leggere preferenze con valori di default
/// - Eliminare preferenze specifiche
/// - Pulire tutte le preferenze
/// 
/// Ideale per impostazioni utente, configurazioni app, e dati non sensibili.
class PreferencesService {
  SharedPreferences? _prefs;

  /// Inizializza il service (chiamare all'avvio dell'app)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Ottiene l'istanza di SharedPreferences (lazy initialization)
  Future<SharedPreferences> get _instance async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  // ==================== STRING ====================

  /// Salva una stringa
  Future<bool> setString(String key, String value) async {
    final prefs = await _instance;
    return await prefs.setString(key, value);
  }

  /// Legge una stringa
  Future<String?> getString(String key, {String? defaultValue}) async {
    final prefs = await _instance;
    return prefs.getString(key) ?? defaultValue;
  }

  // ==================== INT ====================

  /// Salva un intero
  Future<bool> setInt(String key, int value) async {
    final prefs = await _instance;
    return await prefs.setInt(key, value);
  }

  /// Legge un intero
  Future<int?> getInt(String key, {int? defaultValue}) async {
    final prefs = await _instance;
    return prefs.getInt(key) ?? defaultValue;
  }

  /// Incrementa un contatore
  Future<int> incrementCounter(String key) async {
    final prefs = await _instance;
    final currentValue = prefs.getInt(key) ?? 0;
    final newValue = currentValue + 1;
    await prefs.setInt(key, newValue);
    return newValue;
  }

  // ==================== BOOL ====================

  /// Salva un booleano
  Future<bool> setBool(String key, bool value) async {
    final prefs = await _instance;
    return await prefs.setBool(key, value);
  }

  /// Legge un booleano
  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await _instance;
    return prefs.getBool(key) ?? defaultValue;
  }

  // ==================== DOUBLE ====================

  /// Salva un double
  Future<bool> setDouble(String key, double value) async {
    final prefs = await _instance;
    return await prefs.setDouble(key, value);
  }

  /// Legge un double
  Future<double?> getDouble(String key, {double? defaultValue}) async {
    final prefs = await _instance;
    return prefs.getDouble(key) ?? defaultValue;
  }

  // ==================== STRING LIST ====================

  /// Salva una lista di stringhe
  Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _instance;
    return await prefs.setStringList(key, value);
  }

  /// Legge una lista di stringhe
  Future<List<String>> getStringList(
    String key, {
    List<String>? defaultValue,
  }) async {
    final prefs = await _instance;
    return prefs.getStringList(key) ?? defaultValue ?? [];
  }

  // ==================== THEME MODE EXAMPLE ====================

  /// Salva la modalità tema (dark/light)
  Future<bool> setThemeMode(String mode) async {
    return await setString('theme_mode', mode);
  }

  /// Legge la modalità tema
  Future<String> getThemeMode() async {
    return await getString('theme_mode', defaultValue: 'system') ?? 'system';
  }

  // ==================== UTILITY ====================

  /// Verifica se una chiave esiste
  Future<bool> containsKey(String key) async {
    final prefs = await _instance;
    return prefs.containsKey(key);
  }

  /// Elimina una chiave specifica
  Future<bool> remove(String key) async {
    final prefs = await _instance;
    return await prefs.remove(key);
  }

  /// Pulisce tutte le preferenze (usa con cautela!)
  Future<bool> clearAll() async {
    final prefs = await _instance;
    return await prefs.clear();
  }

  /// Ottiene tutte le chiavi salvate
  Future<Set<String>> getAllKeys() async {
    final prefs = await _instance;
    return prefs.getKeys();
  }

  /// Ricarica i valori da disco (raramente necessario)
  Future<void> reload() async {
    final prefs = await _instance;
    await prefs.reload();
  }

  // ==================== EXAMPLES FOR DEMO ====================

  /// Salva le impostazioni utente (esempio per demo)
  Future<bool> saveUserSettings({
    required String userName,
    required String language,
    required bool showTutorial,
  }) async {
    try {
      await setString('user_name', userName);
      await setString('language', language);
      await setBool('show_tutorial', showTutorial);
      return true;
    } catch (e) {
      print('Error saving user settings: $e');
      return false;
    }
  }

  /// Carica le impostazioni utente (esempio per demo)
  Future<Map<String, dynamic>> loadUserSettings() async {
    return {
      'user_name': await getString('user_name', defaultValue: 'Guest'),
      'language': await getString('language', defaultValue: 'en'),
      'show_tutorial': await getBool('show_tutorial', defaultValue: true),
      'app_launch_count':
          await getInt('app_launch_count', defaultValue: 0),
    };
  }
}
