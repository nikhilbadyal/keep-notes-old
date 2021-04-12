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
          _query(),
        );
      }, version: 1);
    }
    return _database;
  }

  static String _query() {
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

  static Future<Note> insertNote(Note note, {bool isNew}) async {
    final db = await database;
    note.id = await db.insert(
      tableName,
      isNew ? note.toMap(isNew: true) : note.toMap(isNew: false),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return note;
  }

  static Future<bool> deleteAllHiddenNotes() async {
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

  static Future<bool> deleteNote(Note note) async {
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

  static Future<bool> deleteAllTrashNote() async {
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

  static Future<bool> undelete(Note note) async {
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

  static Future<bool> trashNote(Note note) async {
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

  static Future<bool> hideNote(Note note) async {
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

  static Future<bool> unhideNote(Note note) async {
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

  static Future<bool> archiveNote(Note note) async {
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

  static Future<bool> unarchiveNote(Note note) async {
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

  static Future<int> copyNote(Note note) async {
    final db = await database;
    await db.insert(
      tableName,
      note.toMap(isNew: true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final one = await db.query(tableName,
        orderBy: 'lastModify DESC',
        where: 'state != ?',
        whereArgs: [2],
        limit: 1);
    final latestId = one.first['id'] as int;
    return latestId;
  }

  static Future<List<Map<String, dynamic>>> selectAllNotes(
      int noteState) async {
    final db = await database;
    final lol = db.query(
      'notes',
      orderBy: 'lastModify desc',
      where: 'state = ?',
      whereArgs: [noteState],
    );
    return lol;
  }

  static Future<List<Map<String, dynamic>>> selectAllNotesForBackup() async {
    final db = await database;
    final lol = db.query('notes', orderBy: 'lastModify desc');
    return lol;
  }

  static Future<bool> addAllNotesToBackup(List<Note> notes) async {
    try {
      for (final note in notes) {
        await insertNote(note, isNew: true);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
