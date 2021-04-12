import 'dart:async';
import 'dart:io';

import 'package:notes/app.dart';
import 'package:notes/model/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ignore: avoid_classes_with_only_static_members
class DatabaseHelper {
  static String tableName = 'notes';

  static final fieldMap = {
    'id': 'INTEGER PRIMARY KEY ',
    'title': 'text',
    'content': 'text',
    'creationDate': 'INTEGER',
    'lastModify': 'INTEGER',
    'color': 'INTEGER',
    'state': 'INTEGER',
    'imagePath': 'text'
  };

  static Database _database;

  static Future<Database> get database async {
    final databasePath = await getDatabasesPath();
    final status = await databaseExists(databasePath);
    if (!status) {
      _database = await openDatabase(join(databasePath, 'notes_database.db'),
          onCreate: (database, version) {
        return database.execute(
          query(),
        );
      }, version: 1);
    }
    return _database;
  }

  static String query() {
    var query = 'CREATE TABLE '; //IF NOT EXISTS
    query += tableName;
    query += '(';
    fieldMap.forEach((key, value) {
      query += '$key $value,';
    });

    query = query.substring(0, query.length - 1);
    query += ')';
    return query;
  }

  static Future<bool> insertNoteDb(Note note, {bool isNew = false}) async {
    final db = await database;
    note.id = await db.insert(
      tableName,
      isNew ? note.toMap(isNew: true) : note.toMap(isNew: false),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  /*static Future<Note> copyNoteDb(Note note) async {
    final db = await database;
    copiedNote.id = await db.insert(
      tableName,
      note.toMap(isNew: true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return note;
  }*/

  static Future<bool> archiveNoteDb(Note note) async {
    if (note.id != -1) {
      final db = await database;
      note.state = NoteState.archived;
      final idToUpdate = note.id;
      await db.update(
        'notes',
        note.toMap(isNew: true),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
      return true;
    }
    return false;
  }

  static Future<bool> hideNoteDb(Note note) async {
    if (note.id != -1) {
      final db = await database;
      note.state = NoteState.hidden;
      final idToUpdate = note.id;
      await db.update(
        'notes',
        note.toMap(isNew: true),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
      return true;
    }
    return false;
  }

  static Future<bool> unhideNoteDb(Note note) async {
    if (note.id != -1) {
      final db = await database;
      note.state = NoteState.unspecified;
      final idToUpdate = note.id;
      await db.update(
        'notes',
        note.toMap(isNew: true),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
      return true;
    }
    return false;
  }

  static Future<bool> unarchiveNoteDb(Note note) async {
    if (note.id != -1) {
      final db = await database;
      note.state = NoteState.unspecified;
      final idToUpdate = note.id;

      await db.update(
        'notes',
        note.toMap(isNew: true),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
      return true;
    }
    return false;
  }

  static Future<bool> undeleteDb(Note note) async {
    if (note.id != -1) {
      final db = await database;
      note.state = NoteState.unspecified;
      final idToUpdate = note.id;

      await db.update(
        'notes',
        note.toMap(isNew: true),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
      return true;
    }
    return false;
  }

  static Future<bool> deleteNoteDb(Note note) async {
    try {
      if (note.id != -1) {
        final db = await database;
        try {
          await db.delete(
            'notes',
            where: 'id = ?',
            whereArgs: [note.id],
          );

          if (note.imagePath != '' && File(note.imagePath).existsSync()) {
            await File(note.imagePath).delete();
          }
          return true;
        } on Error {
          return false;
        }
      }
    } catch (e) {
      rethrow;
    }
    return false;
  }

  static Future<bool> trashNoteDb(Note note) async {
    final db = await database;
    note.state = NoteState.deleted;
    final idToUpdate = note.id;

    await db.update(
      'notes',
      note.toMap(isNew: true),
      where: 'id = ?',
      whereArgs: [idToUpdate],
    );
    return true;
  }

  static Future<bool> deleteAllHiddenNotesDb() async {
    final db = await database;
    try {
      await db.delete(
        'notes',
        where: 'state = ?',
        whereArgs: [3],
      );
      myNotes.lockChecker.passwordSet = false;
      myNotes.lockChecker.updateDetails();
      return true;
    } on Error {
      return false;
    }
  }

  static Future<bool> deleteAllTrashNoteDb() async {
    try {
      final db = await database;
      try {
        await db.delete(
          'notes',
          where: 'state = ?',
          whereArgs: [NoteState.deleted.index],
        );
        return true;
      } on Error {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllNotesDb(int noteState) async {
    final db = await database;
    final lol = db.query(
      'notes',
      orderBy: 'lastModify desc',
      where: 'state = ?',
      whereArgs: [noteState],
    );
    return lol;
  }

  static Future<List<Map<String, dynamic>>> getNotesAllForBackupDb() async {
    final db = await database;
    final lol = db.query('notes', orderBy: 'lastModify desc');
    return lol;
  }

  static Future<bool> addAllNotesToBackupDb(List<Note> notes) async {
    try {
      for (final note in notes) {
        await insertNoteDb(note, isNew: true);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
