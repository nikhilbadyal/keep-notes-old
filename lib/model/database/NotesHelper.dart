import 'package:flutter/material.dart';
import 'package:notes/model/database/database_helper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/Utilites.dart';

class NotesHelper with ChangeNotifier {
  List _mainNotes = [];
  List _otherNotes = [];

  List get mainItems {
    return [..._mainNotes];
  }

  List get otherNotes => [..._otherNotes];

  Future<Note> insertNote(Note note, {bool isNew}) async {
    if (note.id != -1) {}
    if (isNew) {
      note.state == NoteState.unspecified
          ? _mainNotes.insert(0, note)
          : _otherNotes.insert(0, note);
    } else {
      try {
        note.state == NoteState.unspecified
            ? _mainNotes[_mainNotes
                .indexWhere((element) => note.id == element.id)] = note
            : _otherNotes[_otherNotes
                .indexWhere((element) => note.id == element.id)] = note;
      } catch (e) {
        rethrow;
      }
    }
    // ignore: parameter_assignments
    note = await DatabaseHelper.insertNote(note, isNew: isNew);
    notifyListeners();
    return note;
  }

  Future<bool> copyNote(Note note) async {
    if (note.id != -1) {
      note.state == NoteState.unspecified
          ? _mainNotes.insert(0, note)
          : _otherNotes.insert(0, note);
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
      final toDo = note.state;
      await DatabaseHelper.hideNote(note);
      toDo == NoteState.unspecified
          ? await getNotesAll(0)
          : await getNotesAll(2);
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
    var status = false;
    if (note.id == -1) {
      return status;
    }
    try {
      note.state == NoteState.unspecified
          ? _mainNotes.removeWhere((element) => element.id == note.id)
          : _otherNotes.removeWhere((element) => element.id == note.id);
      status = await DatabaseHelper.deleteNote(note);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
    return status;
  }

  Future<bool> deleteAllHiddenNotes() async {
    notifyListeners();
    return DatabaseHelper.deleteAllHiddenNotes();
  }

  Future<bool> trashNote(Note note, BuildContext context) async {
    if (note.id != -1) {
      //TODO fix this
      final nav = note.state.index.toString();
      final stat = await DatabaseHelper.trashNote(note);
      switch (nav) {
        case '0':
          {
            await getNotesAll(0);
            notifyListeners();
            return stat;
          }
          break;
        case '2':
          {
            await getNotesAll(2);
            notifyListeners();
            return stat;
          }
          break;
        case '3':
          {
            await getNotesAll(3);
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

  void falseDelete() {
    // notifyListeners();
  }

  Future getNotesAll(int noteState) async {
    final notesList = await DatabaseHelper.selectAllNotes(noteState);
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

  Future<List> getNotesAllForBackup() async {
    final notesList = await DatabaseHelper.selectAllNotesForBackup();
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

  Future<void> addAllNotesToBackup(List<Note> notesList) async {
    final status = await DatabaseHelper.addAllNotesToBackup(notesList);
    notifyListeners();
    return status;
  }

  Future<bool> deleteAllTrashNotes() async {
    final status = await DatabaseHelper.deleteAllTrashNote();
    await getNotesAll(NoteState.deleted.index);
    notifyListeners();
    return status;
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
