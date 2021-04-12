import 'package:flutter/material.dart';
import 'package:notes/model/database/database_helper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/Utilites.dart';

//Insert
//Copy
//Trash
class NotesHelper with ChangeNotifier {
  List _mainNotes = [];
  List _otherNotes = [];

  List get mainNotes => [..._mainNotes];

  List get otherNotes => [..._otherNotes];

  Future<Note> insertNoteHelper(Note note, {bool isNew = false}) async {
    if (!isNew) {
      note.state == NoteState.unspecified
          ? mainNotes[
              mainNotes.indexWhere((element) => note.id == element.id)] = note
          : otherNotes[
              otherNotes.indexWhere((element) => note.id == element.id)] = note;
    } else {
      note.state == NoteState.unspecified
          ? mainNotes.insert(0, note)
          : mainNotes.insert(0, note);
    }
    await DatabaseHelper.insertNoteDb(note, isNew: isNew);
    notifyListeners();
    return note;
  }

  Future<bool> copyNoteHelper(Note note) async {
    if (note.id != -1) {
      final copiedNote = note.copyWith();
      await DatabaseHelper.insertNoteDb(copiedNote, isNew: true);
      note.state == NoteState.unspecified
          ? _mainNotes.insert(0, note)
          : _otherNotes.insert(0, note);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> archiveNoteHelper(Note note) async {
    if (note.id != -1) {
      await DatabaseHelper.archiveNoteDb(note);
      await getAllNotesHelper(0);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> hideNoteHelper(Note note) async {
    if (note.id != -1) {
      final toDo = note.state;
      await DatabaseHelper.hideNoteDb(note);
      toDo == NoteState.unspecified
          ? await getAllNotesHelper(0)
          : await getAllNotesHelper(2);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> unhideNoteHelper(Note note) async {
    if (note.id != -1) {
      await DatabaseHelper.unhideNoteDb(note);
      await getAllNotesHelper(3);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> unarchiveNoteHelper(Note note) async {
    if (note.id != -1) {
      await DatabaseHelper.unarchiveNoteDb(note);
      await getAllNotesHelper(2);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> undeleteHelper(Note note) async {
    if (note.id == -1) {
      return false;
    }
    await DatabaseHelper.undeleteDb(note);
    await getAllNotesHelper(4);
    notifyListeners();
    return true;
  }

  Future<bool> deleteNoteHelper(Note note) async {
    var status = false;
    if (note.id == -1) {
      return status;
    }
    try {
      note.state == NoteState.unspecified
          ? _mainNotes.removeWhere((element) => element.id == note.id)
          : _otherNotes.removeWhere((element) => element.id == note.id);
      status = await DatabaseHelper.deleteNoteDb(note);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
    return status;
  }

  //Cyan color
  Future<bool> trashNoteHelper(Note note, BuildContext context) async {
    if (note.id != -1) {
      //TODO fix this
      final nav = note.state.index.toString();
      final stat = await DatabaseHelper.trashNoteDb(note);
      switch (nav) {
        case '0':
          {
            await getAllNotesHelper(0);
            notifyListeners();
            return stat;
          }
          break;
        case '2':
          {
            await getAllNotesHelper(2);
            notifyListeners();
            return stat;
          }
          break;
        case '3':
          {
            await getAllNotesHelper(3);
            notifyListeners();
            return stat;
          }
          break;
        default:
          {
            await showDialog(
              context: context,
              builder: (_) {
                return MySimpleDialog(
                  title: const Text(
                      'If you\'re seeing this please consider submitting a bug :'),
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        Utilities.launchUrl(
                          Utilities.emailLaunchUri.toString(),
                        );
                      },
                    )
                  ],
                );
              },
            );
          }
      }
    }
    return false;
  }

  Future<bool> deleteAllHiddenNotesHelper() async {
    notifyListeners();
    return DatabaseHelper.deleteAllHiddenNotesDb();
  }

  Future<bool> deleteAllTrashNotesHelper() async {
    final status = await DatabaseHelper.deleteAllTrashNoteDb();
    await getAllNotesHelper(NoteState.deleted.index);
    notifyListeners();
    return status;
  }

  Future getAllNotesHelper(int noteState, {bool returnCached = true}) async {
    if (returnCached) {
      return;
    }
    final notesList = await DatabaseHelper.getAllNotesDb(noteState);
    noteState == NoteState.unspecified.index
        ? _mainNotes = notesList.map(
            (itemVar) {
              return Note(
                id: itemVar['id'],
                title: itemVar['title'].toString(),
                content: itemVar['content'].toString(),
                creationDate: DateTime.fromMillisecondsSinceEpoch(
                  itemVar['creationDate'],
                ),
                lastModify: DateTime.fromMillisecondsSinceEpoch(
                  itemVar['lastModify'],
                ),
                color: Color(
                  itemVar['color'],
                ),
                state: NoteState.values[itemVar['state']],
                imagePath: itemVar['imagePath'],
              );
            },
          ).toList()
        : _otherNotes = notesList.map(
            (itemVar) {
              return Note(
                id: itemVar['id'],
                title: itemVar['title'].toString(),
                content: itemVar['content'].toString(),
                creationDate: DateTime.fromMillisecondsSinceEpoch(
                  itemVar['creationDate'],
                ),
                lastModify: DateTime.fromMillisecondsSinceEpoch(
                  itemVar['lastModify'],
                ),
                color: Color(
                  itemVar['color'],
                ),
                state: NoteState.values[itemVar['state']],
                imagePath: itemVar['imagePath'],
              );
            },
          ).toList();
  }

  Future<List> getNotesAllForBackupHelper() async {
    final notesList = await DatabaseHelper.getNotesAllForBackupDb();
    final items = notesList.map(
      (itemVar) {
        return Note(
          id: itemVar['id'],
          title: itemVar['title'].toString(),
          content: itemVar['content'].toString(),
          creationDate: DateTime.fromMillisecondsSinceEpoch(
            itemVar['creationDate'],
          ),
          lastModify: DateTime.fromMillisecondsSinceEpoch(
            itemVar['lastModify'],
          ),
          color: Color(
            itemVar['color'],
          ),
          state: NoteState.values[itemVar['state']],
          imagePath: itemVar['imagePath'],
        );
      },
    ).toList();
    return items;
  }

  Future<void> addAllNotesToBackupHelper(List<Note> notesList) async {
    final status = await DatabaseHelper.addAllNotesToBackupDb(notesList);
    notifyListeners();
    return status;
  }

  void falseDelete() {
    // notifyListeners();
  }
}

class MySimpleDialog extends StatelessWidget {
  const MySimpleDialog({Key key, this.title, this.children}) : super(key: key);

  final Widget title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final fake = <Widget>[];
    if (children == null) {
      fake.add(Container(
        height: 20,
      ));
    }
    return SimpleDialog(
      title: Center(
        child: title,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      children: children ?? fake,
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({Key key, this.title, this.actions, this.content})
      : super(key: key);

  final Widget title;
  final List<Widget> actions;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: content,
      actions: actions,
    );
  }
}
