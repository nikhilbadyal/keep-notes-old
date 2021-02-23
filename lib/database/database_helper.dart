import 'dart:async';
import 'dart:io';

import 'package:notes/database/note.dart';
import 'package:notes/screens/LockScreen.dart';
import 'package:notes/util/Utilites.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // static Database _database;
  static String tableName = 'notes';
  static var statPath;

  static final fieldMap = {
    'id': 'INTEGER PRIMARY KEY ', //AUTOINCREMENT
    'title': 'text',
    'content': 'text',
    'creationDate': 'INTEGER',
    'lastModify': 'INTEGER',
    'color': 'INTEGER',
    'state': 'INTEGER',
    'imagePath': 'text'
  };

  static Future<Database> get database async {
    final databasePath = await getDatabasesPath();
    return openDatabase(join(databasePath, 'notes_database.db'),
        onCreate: (database, version) {
      return database.execute(_query());
    }, version: 1);
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

  static Future<Note> insertNote(Note note, bool isNew) async {
    // debugPrint("This is the content"+ note.content);
    // debugPrint('Inserting Note database helper.');
    final db = await database;
    note.id = await db.insert(
      tableName,
      isNew ? note.toMap(true) : note.toMap(false),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    /* if (isNew) {
      var one = await db.query(tableName, orderBy: 'lastModify DESC', limit: 1);
      var latestId = one.first['id'] as int;
      return latestId;
    }*/
    return note;
  }

  static Future<bool> deleteAllHiddenNotes() async {
    final db = await database;
    try {
      await db.delete('notes', where: 'state = ?', whereArgs: [3]);
      LockChecker.passwordSet = false;
      await Utilities.removeValues('password');
      await Utilities.removeValues('bio');
      await LockChecker.updateDetails();
      return true;
    } on Error {
      return false;
    }
  }

  static Future<bool> deleteNote(Note note) async {
    if (note.id != -1) {
      final db = await database;
      try {
        await db.delete('notes', where: 'id = ?', whereArgs: [note.id]);

        if (note.imagePath != "" && await File(note.imagePath).exists()) {
          await File(note.imagePath).delete();
        }
        return true;
      } on Error {
        return false;
      }
    }
    return false;
  }

  static Future<bool> undelete(Note note) async {
    if (note.id != -1) {
      final db = await database;
      note.state = NoteState.unspecified;
      var idToUpdate = note.id;

      await db.update('notes', note.toMap(true),
          where: 'id = ?', whereArgs: [idToUpdate]);
      return true;
    }
    return false;
  }

  static Future<bool> trashNote(Note note) async {
    final db = await database;
    note.state = NoteState.deleted;
    var idToUpdate = note.id;

    await db.update('notes', note.toMap(true),
        where: 'id = ?', whereArgs: [idToUpdate]);
    return true;
  }

  static Future<bool> hideNote(Note note) async {
    if (note.id != -1) {
      final db = await database;
      note.state = NoteState.hidden;
      var idToUpdate = note.id;
      await db.update('notes', note.toMap(true),
          where: 'id = ?', whereArgs: [idToUpdate]);
      return true;
    }
    return false;
  }

  static Future<bool> unhideNote(Note note) async {
    if (note.id != -1) {
      final db = await database;
      note.state = NoteState.unspecified;
      var idToUpdate = note.id;
      await db.update('notes', note.toMap(true),
          where: 'id = ?', whereArgs: [idToUpdate]);
      return true;
    }
    return false;
  }

  static Future<bool> archiveNote(Note note) async {
    if (note.id != -1) {
      final db = await database;
      note.state = NoteState.archived;
      var idToUpdate = note.id;
      await db.update('notes', note.toMap(true),
          where: 'id = ?', whereArgs: [idToUpdate]);
      return true;
    }
    return false;
  }

  static Future<bool> unarchiveNote(Note note) async {
    if (note.id != -1) {
      final db = await database;
      note.state = NoteState.unspecified;
      var idToUpdate = note.id;

      await db.update('notes', note.toMap(true),
          where: 'id = ?', whereArgs: [idToUpdate]);
      return true;
    }
    return false;
  }

  static Future<int> copyNote(Note note) async {
    final db = await database;
    await db.insert(
      tableName,
      note.toMap(false),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    var one = await db.query(tableName,
        orderBy: 'lastModify DESC',
        where: 'state != ?',
        whereArgs: [2],
        limit: 1);
    var latestId = one.first['id'] as int;
    return latestId;
  }

  static Future<List<Map<String, dynamic>>> selectAllNotes(
      int noteState) async {
    final db = await database;

    // query all the notes sorted by last edited
    var lol = db.query('notes',
        orderBy: 'lastModify desc', where: 'state = ?', whereArgs: [noteState]);
    return lol;
  }
}
