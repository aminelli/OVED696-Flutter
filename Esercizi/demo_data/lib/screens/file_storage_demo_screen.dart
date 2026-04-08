import 'package:flutter/material.dart';
import '../services/file_storage_service.dart';
import '../models/note_model.dart';

/// Schermata demo per File Storage (path_provider).
/// 
/// Permette di:
/// - Creare nuove note salvate come file
/// - Visualizzare tutte le note salvate
/// - Modificare note esistenti
/// - Eliminare note
/// - Vedere i path delle directory
class FileStorageDemoScreen extends StatefulWidget {
  const FileStorageDemoScreen({super.key});

  @override
  State<FileStorageDemoScreen> createState() => _FileStorageDemoScreenState();
}

class _FileStorageDemoScreenState extends State<FileStorageDemoScreen> {
  final FileStorageService _storageService = FileStorageService();
  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _documentsPath;
  String? _tempPath;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadPaths();
  }

  /// Carica tutte le note salvate
  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    try {
      final notes = await _storageService.getAllNotes();
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error loading notes: $e');
    }
  }

  /// Carica i path delle directory
  Future<void> _loadPaths() async {
    try {
      final docsPath = await _storageService.getDocumentsPath();
      final tmpPath = await _storageService.getTempPath();
      setState(() {
        _documentsPath = docsPath;
        _tempPath = tmpPath;
      });
    } catch (e) {
      print('Error loading paths: $e');
    }
  }

  /// Mostra dialog per creare/modificare una nota
  Future<void> _showNoteDialog({NoteModel? note}) async {
    final isEditing = note != null;
    final filenameController =
        TextEditingController(text: note?.filename ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: filenameController,
                decoration: const InputDecoration(
                  labelText: 'Filename',
                  hintText: 'my_note',
                  border: OutlineInputBorder(),
                ),
                enabled: !isEditing, // Non modificabile in edit
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  hintText: 'Enter your note content...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final filename = filenameController.text.trim();
              final content = contentController.text.trim();

              if (filename.isEmpty || content.isEmpty) {
                _showError('Filename and content cannot be empty');
                return;
              }

              Navigator.pop(context);

              final newNote = NoteModel(
                filename: filename,
                content: content,
              );

              final success = await _storageService.saveNote(newNote);
              if (success) {
                _showSuccess(
                    isEditing ? 'Note updated!' : 'Note saved!');
                _loadNotes();
              } else {
                _showError('Failed to save note');
              }
            },
            child: Text(isEditing ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  /// Elimina una nota
  Future<void> _deleteNote(NoteModel note) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.filename}"?'),
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _storageService.deleteNote(note.filename);
      if (success) {
        _showSuccess('Note deleted!');
        _loadNotes();
      } else {
        _showError('Failed to delete note');
      }
    }
  }

  /// Mostra dialog con i path delle directory
  void _showPathsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Paths'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Documents Directory:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              SelectableText(
                _documentsPath ?? 'Loading...',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              const Text(
                'Temporary Directory:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              SelectableText(
                _tempPath ?? 'Loading...',
                style: const TextStyle(fontSize: 12),
              ),
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
        title: const Text('File Storage Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _showPathsDialog,
            tooltip: 'Show Paths',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotes,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
              ? _buildEmptyState()
              : _buildNotesList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNoteDialog(),
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No notes yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first note',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: const Icon(Icons.description, color: Colors.white),
            ),
            title: Text(
              note.filename,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.content.length > 50
                      ? '${note.content.substring(0, 50)}...'
                      : note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Modified: ${_formatDate(note.lastModified)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showNoteDialog(note: note);
                } else if (value == 'delete') {
                  _deleteNote(note);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () => _showNoteDialog(note: note),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
