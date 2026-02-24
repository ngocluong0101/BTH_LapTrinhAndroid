import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteService {
  static const String _notesKey = 'notes';

  // Load all notes from SharedPreferences
  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];
    return notesJson.map((json) => Note.fromJson(jsonDecode(json))).toList();
  }

  // Save all notes to SharedPreferences
  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((note) => jsonEncode(note.toJson())).toList();
    await prefs.setStringList(_notesKey, notesJson);
  }

  // Add a new note
  Future<void> addNote(Note note) async {
    final notes = await loadNotes();
    notes.add(note);
    await saveNotes(notes);
  }

  // Update an existing note
  Future<void> updateNote(Note updatedNote) async {
    final notes = await loadNotes();
    final index = notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
      await saveNotes(notes);
    }
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    final notes = await loadNotes();
    notes.removeWhere((note) => note.id == id);
    await saveNotes(notes);
  }
}
