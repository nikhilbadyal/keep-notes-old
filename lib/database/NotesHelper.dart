import 'package:flutter/material.dart';
import 'package:notes/database/database_helper.dart';
import 'package:notes/database/note.dart';

class NotesHelper with ChangeNotifier {
  List _items = [];

  List get items {
    return [..._items];
  }

  Future<Note> insertNote(Note note, bool isNew) async {
    if (note.id != -1) {}
    if (isNew) {
      _items.insert(0, note);
    } else {
      _items[_items.indexWhere((element) => note.id == element.id)] = note;
    }
    note = await DatabaseHelper.insertNote(note, isNew);
    notifyListeners();
    return note;
  }

  Future<bool> copyNote(Note note) async {
    if (note.id != -1) {
      print(_items.length);
      _items.insert(0, note);
      print(_items.length);

      await DatabaseHelper.copyNote(note);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> archiveNote(Note note) async {
    if (note.id != -1) {
      await DatabaseHelper.archiveNote(note);
      await getNotesAll(0);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> hideNote(Note note) async {
    if (note.id != -1) {
      await DatabaseHelper.hideNote(note);
      await getNotesAll(0);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> unhideNote(Note note) async {
    if (note.id != -1) {
      await DatabaseHelper.unhideNote(note);
      await getNotesAll(3);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> unarchiveNote(Note note) async {
    if (note.id != -1) {
      await DatabaseHelper.unarchiveNote(note);
      await getNotesAll(2);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> undelete(Note note) async {
    if (note.id == -1) {
      return false;
    }
    await DatabaseHelper.undelete(note);
    await getNotesAll(4);
    notifyListeners();
    return true;
  }

  Future<bool> deleteNote(Note note) async {
    bool status = false;
    if (note.id == -1) {
      return status;
    }
    try {
      _items.removeWhere((element) => element.id == note.id);
      status = await DatabaseHelper.deleteNote(note);
    } catch (e) {
      print(e);
    }
    print(status);
    notifyListeners();
    return status;
  }

  Future<bool> deleteAllHiddenNotes() async {
    notifyListeners();
    return DatabaseHelper.deleteAllHiddenNotes();
  }

  Future<void> trashNote(
      {Note note, BuildContext context, @required NoteState fromWhere}) async {
    if (note.id != -1) {
      var nav = fromWhere.index.toString();
      switch (nav) {
        case '0':
          {
            await DatabaseHelper.trashNote(note);
            await getNotesAll(0);
          }
          break;
        case '2':
          {
            await DatabaseHelper.trashNote(note);
            await getNotesAll(2);
          }
          break;
        case '3':
          {
            await DatabaseHelper.trashNote(note);
            await getNotesAll(3);
          }
          break;
        default:
          {
            AlertDialog(
              content: Text(
                  'If you\'re seeing this please consider submitting a bug :-)'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () async {
                    await Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                  },
                ),
              ],
            );
          }
      }
      notifyListeners();
    }
  }

  void falseDelete() {
    notifyListeners();
  }

  Future getNotesAll(int noteState) async {
    final notesList = await DatabaseHelper.selectAllNotes(noteState);
    _items = notesList.map(
      (itemVar) {
        return Note(
            id: itemVar['id'],
            title: itemVar['title'].toString(),
            content: itemVar['content'].toString(),
            creationDate:
                DateTime.fromMillisecondsSinceEpoch(itemVar['creationDate']),
            lastModify:
                DateTime.fromMillisecondsSinceEpoch(itemVar['lastModify']),
            color: Color(itemVar['color']),
            state: NoteState.values[itemVar['state']],
            imagePath: itemVar['imagePath']);
      },
    ).toList();
  }

  Future<List> getNotesAllForBackup() async {
    final notesList = await DatabaseHelper.selectAllNotesForBackup();
    List items = notesList.map(
      (itemVar) {
        return Note(
            id: itemVar['id'],
            title: itemVar['title'].toString(),
            content: itemVar['content'].toString(),
            creationDate:
                DateTime.fromMillisecondsSinceEpoch(itemVar['creationDate']),
            lastModify:
                DateTime.fromMillisecondsSinceEpoch(itemVar['lastModify']),
            color: Color(itemVar['color']),
            state: NoteState.values[itemVar['state']],
            imagePath: itemVar['imagePath']);
      },
    ).toList();
    return items;
  }

  Future<void> addAllNotesToBackup(List<Note> notesList) async {
    bool status = await DatabaseHelper.addAllNotesToBackup(notesList);
    notifyListeners();
    return status;
  }

  Future<bool> deleteAllTrashNotes() async {
    bool status = await DatabaseHelper.deleteAllTrashNote();
    notifyListeners();
    return status;
  }
}
