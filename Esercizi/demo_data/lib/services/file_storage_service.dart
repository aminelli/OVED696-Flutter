import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/note_model.dart';

/// Service per gestire la persistenza su File System usando path_provider.
/// 
/// Permette di:
/// - Salvare note come file di testo
/// - Leggere note salvate
/// - Eliminare note
/// - Ottenere la lista di tutte le note
/// 
/// Le note vengono salvate nella directory dei documenti dell'app.
class FileStorageService {
  /// Ottiene la directory dei documenti dell'applicazione
  Future<Directory> get _documentsDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  /// Ottiene la directory temporanea dell'applicazione
  Future<Directory> get _tempDirectory async {
    return await getTemporaryDirectory();
  }

  /// Salva una nota come file di testo
  /// 
  /// [note] la nota da salvare
  /// Ritorna true se il salvataggio ha successo
  Future<bool> saveNote(NoteModel note) async {
    try {
      final directory = await _documentsDirectory;
      final file = File('${directory.path}/${note.filename}.txt');
      
      // Crea il file con il contenuto della nota
      await file.writeAsString(note.content, encoding: utf8);
      
      // Salva anche i metadata in JSON
      final metadataFile = File('${directory.path}/${note.filename}.json');
      await metadataFile.writeAsString(json.encode(note.toJson()));
      
      return true;
    } catch (e) {
      print('Error saving note: $e');
      return false;
    }
  }

  /// Legge una nota dal file system
  /// 
  /// [filename] nome del file (senza estensione)
  /// Ritorna il NoteModel o null se non trovato
  Future<NoteModel?> readNote(String filename) async {
    try {
      final directory = await _documentsDirectory;
      final file = File('${directory.path}/$filename.txt');
      
      if (!await file.exists()) {
        return null;
      }
      
      final content = await file.readAsString(encoding: utf8);
      
      // Leggi anche i metadata se disponibili
      final metadataFile = File('${directory.path}/$filename.json');
      if (await metadataFile.exists()) {
        final jsonString = await metadataFile.readAsString();
        return NoteModel.fromJson(json.decode(jsonString));
      }
      
      // Se non ci sono metadata, crea un nuovo NoteModel
      return NoteModel(
        filename: filename,
        content: content,
        lastModified: await file.lastModified(),
      );
    } catch (e) {
      print('Error reading note: $e');
      return null;
    }
  }

  /// Elimina una nota dal file system
  /// 
  /// [filename] nome del file da eliminare (senza estensione)
  /// Ritorna true se l'eliminazione ha successo
  Future<bool> deleteNote(String filename) async {
    try {
      final directory = await _documentsDirectory;
      
      // Elimina il file di contenuto
      final file = File('${directory.path}/$filename.txt');
      if (await file.exists()) {
        await file.delete();
      }
      
      // Elimina il file di metadata
      final metadataFile = File('${directory.path}/$filename.json');
      if (await metadataFile.exists()) {
        await metadataFile.delete();
      }
      
      return true;
    } catch (e) {
      print('Error deleting note: $e');
      return false;
    }
  }

  /// Ottiene la lista di tutte le note salvate
  /// 
  /// Ritorna una lista di NoteModel
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final directory = await _documentsDirectory;
      final files = directory.listSync();
      
      final notes = <NoteModel>[];
      
      for (final file in files) {
        if (file is File && file.path.endsWith('.txt')) {
          final filename = file.path
              .split(Platform.pathSeparator)
              .last
              .replaceAll('.txt', '');
          
          final note = await readNote(filename);
          if (note != null) {
            notes.add(note);
          }
        }
      }
      
      // Ordina per data di modifica (più recenti prima)
      notes.sort((a, b) => b.lastModified.compareTo(a.lastModified));
      
      return notes;
    } catch (e) {
      print('Error getting all notes: $e');
      return [];
    }
  }

  /// Ottiene il percorso della directory documenti
  Future<String> getDocumentsPath() async {
    final directory = await _documentsDirectory;
    return directory.path;
  }

  /// Ottiene il percorso della directory temporanea
  Future<String> getTempPath() async {
    final directory = await _tempDirectory;
    return directory.path;
  }

  /// Pulisce i file temporanei (opzionale, per demo)
  Future<void> cleanTempFiles() async {
    try {
      final directory = await _tempDirectory;
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        await directory.create();
      }
    } catch (e) {
      print('Error cleaning temp files: $e');
    }
  }

  /// Verifica se una nota esiste
  Future<bool> noteExists(String filename) async {
    try {
      final directory = await _documentsDirectory;
      final file = File('${directory.path}/$filename.txt');
      return await file.exists();
    } catch (e) {
      print('Error checking note existence: $e');
      return false;
    }
  }
}
