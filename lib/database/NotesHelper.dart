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
      try {
        _items[_items.indexWhere((element) => note.id == element.id)] = note;
      } catch (e) {}
    }
    note = await DatabaseHelper.insertNote(note, isNew);
    notifyListeners();
    return note;
  }

  Future<bool> copyNote(Note note) async {
    if (note.id != -1) {
      _items.insert(0, note);
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

  Future<bool> unHideNote(Note note) async {
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
    } catch (e) {}
    notifyListeners();
    return status;
  }

  Future<bool> deleteAllHiddenNotes() async {
    notifyListeners();
    return DatabaseHelper.deleteAllHiddenNotes();
  }

  Future<bool> trashNote({Note note, BuildContext context}) async {
    if (note.id != -1) {
      //TODO fix this
      var nav = note.state.index.toString();
      switch (nav) {
        case '0':
          {
            bool stat = await DatabaseHelper.trashNote(note);
            await getNotesAll(0);
            notifyListeners();
            return stat;
          }
          break;
        case '2':
          {
            bool stat = await DatabaseHelper.trashNote(note);
            await getNotesAll(2);
            notifyListeners();

            return stat;
          }
          break;
        case '3':
          {
            bool stat = await DatabaseHelper.trashNote(note);
            await getNotesAll(3);
            notifyListeners();
            return stat;
          }
          break;
        default:
          {
            AlertDialog(
              content: const Text(
                  'If you\'re seeing this please consider submitting a bug :-)'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () async {
                    bool stat = await Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                            '/', (Route<dynamic> route) => false);
                    notifyListeners();
                    return stat;
                  },
                ),
              ],
            );
          }
      }
    }
    return false;
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
