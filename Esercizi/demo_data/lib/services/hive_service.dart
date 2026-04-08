import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_hive_model.dart';

/// Service per gestire il database Hive.
/// 
/// Hive è un database NoSQL leggero e veloce, ottimizzato per Flutter.
/// Caratteristiche:
/// - Scritto in Dart puro, nessuna dipendenza nativa
/// - Molto veloce (più di SharedPreferences e SQLite in molti casi)
/// - Type-safe con code generation
/// - Supporta encryption out-of-the-box
/// - Funziona su tutte le piattaforme (mobile, desktop, web)
/// 
/// Questo servizio implementa operazioni CRUD complete per le note.
class HiveService {
  static const String _boxName = 'notes_box';
  static Box<NoteHiveModel>? _notesBox;

  /// Ottiene il box delle note (lazy initialization)
  static Future<Box<NoteHiveModel>> get _box async {
    if (_notesBox != null && _notesBox!.isOpen) {
      return _notesBox!;
    }
    _notesBox = await Hive.openBox<NoteHiveModel>(_boxName);
    return _notesBox!;
  }

  /// Inizializza Hive e registra gli adapter
  /// Chiamare questo metodo nel main() prima di runApp()
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Registra il TypeAdapter generato
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteHiveModelAdapter());
    }
    
    // Apri il box
    await Hive.openBox<NoteHiveModel>(_boxName);
  }

  /// Crea una nuova nota
  Future<void> createNote(NoteHiveModel note) async {
    final box = await _box;
    await box.put(note.id, note);
  }

  /// Ottiene tutte le note
  Future<List<NoteHiveModel>> getAllNotes() async {
    final box = await _box;
    return box.values.toList();
  }

  /// Ottiene una nota specifica per ID
  Future<NoteHiveModel?> getNoteById(String id) async {
    final box = await _box;
    return box.get(id);
  }

  /// Ottiene le note filtrate per categoria
  Future<List<NoteHiveModel>> getNotesByCategory(String category) async {
    final box = await _box;
    return box.values.where((note) => note.category == category).toList();
  }

  /// Ottiene le note preferite
  Future<List<NoteHiveModel>> getFavoriteNotes() async {
    final box = await _box;
    return box.values.where((note) => note.isFavorite).toList();
  }

  /// Aggiorna una nota esistente
  Future<void> updateNote(NoteHiveModel note) async {
    final box = await _box;
    note.updatedAt = DateTime.now();
    await box.put(note.id, note);
  }

  /// Elimina una nota
  Future<void> deleteNote(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  /// Elimina tutte le note
  Future<void> deleteAllNotes() async {
    final box = await _box;
    await box.clear();
  }

  /// Cerca note per testo (titolo o contenuto)
  Future<List<NoteHiveModel>> searchNotes(String query) async {
    if (query.isEmpty) return getAllNotes();
    
    final box = await _box;
    final lowerQuery = query.toLowerCase();
    
    return box.values.where((note) {
      return note.title.toLowerCase().contains(lowerQuery) ||
             note.content.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String id) async {
    final box = await _box;
    final note = box.get(id);
    if (note != null) {
      note.isFavorite = !note.isFavorite;
      note.updatedAt = DateTime.now();
      await note.save(); // HiveObject method
    }
  }

  /// Ottiene statistiche del database
  Future<Map<String, dynamic>> getStats() async {
    final box = await _box;
    final allNotes = box.values.toList();
    
    final categories = <String>{};
    int favorites = 0;
    
    for (var note in allNotes) {
      if (note.category != null && note.category!.isNotEmpty) {
        categories.add(note.category!);
      }
      if (note.isFavorite) favorites++;
    }
    
    return {
      'totalNotes': allNotes.length,
      'favorites': favorites,
      'categories': categories.length,
      'categoryList': categories.toList(),
      'boxSize': box.length,
    };
  }

  /// Inserisce dati di esempio
  Future<void> insertSampleData() async {
    final now = DateTime.now();
    
    final samples = [
      NoteHiveModel(
        id: 'sample_1',
        title: 'Welcome to Hive!',
        content: 'Hive is a lightweight and blazing fast key-value database written in pure Dart. Perfect for Flutter apps!',
        createdAt: now.subtract(const Duration(days: 7)),
        category: 'Info',
        isFavorite: true,
      ),
      NoteHiveModel(
        id: 'sample_2',
        title: 'Why Hive?',
        content: 'Hive offers:\n• No native dependencies\n• Cross-platform support\n• Type safety\n• Built-in encryption\n• Excellent performance',
        createdAt: now.subtract(const Duration(days: 5)),
        category: 'Info',
      ),
      NoteHiveModel(
        id: 'sample_3',
        title: 'Shopping List',
        content: '🛒 Buy:\n- Milk\n- Bread\n- Eggs\n- Coffee',
        createdAt: now.subtract(const Duration(days: 2)),
        category: 'Personal',
        isFavorite: false,
      ),
      NoteHiveModel(
        id: 'sample_4',
        title: 'Flutter Tips',
        content: 'Remember to:\n1. Use const constructors\n2. Avoid rebuilds\n3. Profile your app\n4. Use proper state management',
        createdAt: now.subtract(const Duration(hours: 12)),
        category: 'Dev',
        isFavorite: true,
      ),
    ];
    
    for (var note in samples) {
      await createNote(note);
    }
  }

  /// Chiude il box (chiamare quando l'app viene chiusa)
  Future<void> close() async {
    await _notesBox?.close();
    _notesBox = null;
  }

  /// Compatta il database (ottimizza lo spazio)
  Future<void> compact() async {
    final box = await _box;
    await box.compact();
  }
}
