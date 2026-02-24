import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baithuchanh02/models/note.dart';
import 'package:baithuchanh02/services/note_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NoteService Tests', () {
    late NoteService noteService;

    setUp(() {
      noteService = NoteService();
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('Save and load notes', () async {
      // Create test notes
      final note1 = Note(
        id: '1',
        title: 'Test Note 1',
        content: 'Content 1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final note2 = Note(
        id: '2',
        title: 'Test Note 2',
        content: 'Content 2',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save notes
      await noteService.saveNotes([note1, note2]);

      // Load notes
      final loadedNotes = await noteService.loadNotes();

      // Verify
      expect(loadedNotes.length, 2);
      expect(loadedNotes[0].id, '1');
      expect(loadedNotes[0].title, 'Test Note 1');
      expect(loadedNotes[1].id, '2');
      expect(loadedNotes[1].title, 'Test Note 2');
    });

    test('Add note', () async {
      final note = Note(
        id: '1',
        title: 'New Note',
        content: 'New Content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await noteService.addNote(note);
      final loadedNotes = await noteService.loadNotes();

      expect(loadedNotes.length, 1);
      expect(loadedNotes[0].title, 'New Note');
    });

    test('Update note', () async {
      final note = Note(
        id: '1',
        title: 'Original',
        content: 'Original Content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await noteService.addNote(note);

      final updatedNote = note.copyWith(
        title: 'Updated',
        content: 'Updated Content',
      );
      await noteService.updateNote(updatedNote);

      final loadedNotes = await noteService.loadNotes();
      expect(loadedNotes.length, 1);
      expect(loadedNotes[0].title, 'Updated');
      expect(loadedNotes[0].content, 'Updated Content');
    });

    test('Delete note', () async {
      final note1 = Note(
        id: '1',
        title: 'Note 1',
        content: 'Content 1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final note2 = Note(
        id: '2',
        title: 'Note 2',
        content: 'Content 2',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await noteService.addNote(note1);
      await noteService.addNote(note2);

      await noteService.deleteNote('1');

      final loadedNotes = await noteService.loadNotes();
      expect(loadedNotes.length, 1);
      expect(loadedNotes[0].id, '2');
    });

    test('JSON serialization', () async {
      final note = Note(
        id: 'test-id',
        title: 'Test Title',
        content: 'Test Content',
        createdAt: DateTime(2023, 1, 1, 12, 0),
        updatedAt: DateTime(2023, 1, 1, 12, 30),
      );

      // Test toJson
      final json = note.toJson();
      expect(json['id'], 'test-id');
      expect(json['title'], 'Test Title');
      expect(json['content'], 'Test Content');
      expect(json['createdAt'], '2023-01-01T12:00:00.000');
      expect(json['updatedAt'], '2023-01-01T12:30:00.000');

      // Test fromJson
      final fromJson = Note.fromJson(json);
      expect(fromJson.id, note.id);
      expect(fromJson.title, note.title);
      expect(fromJson.content, note.content);
      expect(fromJson.createdAt, note.createdAt);
      expect(fromJson.updatedAt, note.updatedAt);
    });
  });
}
