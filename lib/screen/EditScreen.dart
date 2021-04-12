import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/screen/MoreOptionsMenu.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/Utilites.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditScreen extends StatefulWidget {
  EditScreen(
      {@required this.currentNote,
      this.shouldAutoFocus = false,
      @required this.fromWhere,
      @required this.isImageNote});

  final Note currentNote;
  final bool shouldAutoFocus;
  bool isImageNote; //TODO fix this and make this final
  final NoteState fromWhere;

  @override
  _EditScreenState createState() => _EditScreenState();
}
/*
class CharCount with ChangeNotifier {
  int textLength = 0;

  void change(int value) {
    textLength = value;
    notifyListeners();
  }
}*/

class _EditScreenState extends State<EditScreen> {
  bool isReadOnly = false;

  @override
  void initState() {
    super.initState();
    noteInEditing = widget.currentNote;
    _titleController.text = noteInEditing.title;
    _contentController.text = noteInEditing.content;
    noteColor = noteInEditing.color;
    _titleFromInitial = widget.currentNote.title;
    _contentFromInitial = widget.currentNote.content;
    _imagePathFromInitial = widget.currentNote.imagePath;
    if (widget.currentNote.id == -1) {
      isNew = true;
    }
    _autoSaver = Timer.periodic(const Duration(seconds: 5), (timer) {
      saveNote();
    });
  }

  bool isNewNote;
  Note noteInEditing;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Color noteColor;
  bool isNew = false;
  File _image;

  String _titleFromInitial;
  String _contentFromInitial;
  String _imagePathFromInitial;
  String oldName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (noteInEditing.imagePath != '') {
      // _image = File(noteInEditing.imagePath);
    } else {
      _image = null;
    }
  }

  Timer _autoSaver;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 10');
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: _appbar(context),
        body: _body(context),
        //TODO fix this
        bottomSheet: _bottomBar(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          bottom: kBottomNavigationBarHeight, left: 10, right: 10),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            TextField(
              readOnly: isReadOnly,
              controller: _titleController,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
              decoration: const InputDecoration(
                  hintText: 'Enter Note Title', border: InputBorder.none),
            ),
            TextField(
              //TODO fix this issue
              autofocus: widget.shouldAutoFocus,
              readOnly: isReadOnly,
              controller: _contentController,
              maxLines: null,
              showCursor: true,
              style: const TextStyle(
                fontSize: 15.0,
              ),
              /*onChanged: (value) {
                final counter = Provider.of<CharCount>(context, listen: false);
                counter.change(value.length);
              },*/
              decoration: const InputDecoration(
                  hintText: 'Enter Content', border: InputBorder.none),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  Future<void> deleteImage() async {
    if (File(oldName).existsSync()) {
      await File(oldName).delete();
    } else {}
  }

  Widget _bottomBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Theme.of(context).canvasColor,
        height: kBottomNavigationBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.lock_outline),
              onPressed: onPressed,
              color: isReadOnly
                  ? selectedPrimaryColor
                  : selectedAppTheme == AppTheme.Light
                      ? Colors.black
                      : Colors.white,
            ),
            /*SizedBox(
              width: MediaQuery.of(context).size.width / 6,
            ),*/
            Center(
              child: Text(
                'Modified ${noteInEditing.strLastModifiedDate1}',
              ),
            ),
            IconButton(
              onPressed: () {
                _moreMenu(context);
              },
              icon: const Icon(Icons.more_vert_outlined),
              color: Utilities.iconColor(),
              tooltip: 'More ',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPress() async {
    _autoSaver.cancel();
    await saveNote();
    Navigator.of(context).pop();
    return true;
  }

  Future<void> saveNote() async {
    final isEdited = updateNote();
    final isEmptyNote = isEmpty();
    if (isEdited) {
      if (noteInEditing.id == -1) {
        if (!isEmptyNote) {
          //debugPrint('here');
          final noteIn = Provider.of<NotesHelper>(context, listen: false)
              .insertNote(noteInEditing, isNew: true);
          await noteIn.then((value) => noteInEditing = value);
        }
      } else {
        if (isEmptyNote) {
          //debugPrint('empty');
          await Provider.of<NotesHelper>(context, listen: false)
              .deleteNote(noteInEditing);
        } else {
          final noteIn = Provider.of<NotesHelper>(context, listen: false)
              .insertNote(noteInEditing, isNew: false);
          await noteIn.then((value) => noteInEditing = value);
        }
      }
      Utilities.getSnackBar(
        context,
        'Note Saved',
        const Duration(seconds: 2),
      );
      return;
    }
    //debugPrint('not edited');
  }

  bool isEmpty() {
    if (noteInEditing.title == '' &&
        noteInEditing.content == '' &&
        noteInEditing.imagePath == '') {
      return true;
    }
    return false;
  }

  bool updateNote() {
    noteInEditing.title = _titleController.text.trim();
    noteInEditing.content = _contentController.text.trim();
    if (_image == null) {
    } else {}
    noteInEditing.imagePath = _image != null ? _image.path : '';
    noteInEditing.color = noteColor;

    if (widget.isImageNote) {
      //debugPrint('Date updated 1');
      noteInEditing.lastModify = DateTime.now();
      widget.isImageNote = false;
      return true;
    }
    if (isNew &&
        !(noteInEditing.title == _titleFromInitial &&
            noteInEditing.content == _contentFromInitial &&
            noteInEditing.imagePath == _imagePathFromInitial)) {
      //debugPrint('Date updated 2');
      noteInEditing.lastModify = DateTime.now();
      return true;
    } else if (!(noteInEditing.title == _titleFromInitial &&
        noteInEditing.content == _contentFromInitial &&
        noteInEditing.imagePath == _imagePathFromInitial)) {
      noteInEditing.lastModify = DateTime.now();
      return true;
    }
    return false;
  }

  /* void _showDialog(BuildContext context, Note note, NoteState fromWhere) {
    showDialog(
        context: context,
        builder: (context) {
          return DeletePopUp(note, _autoSaver, fromWhere);
        });
  }*/

  Future<void> exitWithoutSaving(BuildContext context) async {
    _autoSaver.cancel();
    Navigator.pop(context);
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: _onBackPress,
        color: Colors.white,
      ),
      // actions: _appbarAction(context),
      elevation: 1,
    );
  }

  /* List<Widget> _appbarAction(BuildContext context) {
    final actions = <Widget>[];
    actions.add(Consumer<CharCount>(
      builder: (context, counter, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 25, right: 10),
          child: Text(counter.textLength.toString()),
        );
      },
    ));
    return actions;
  }*/

  /*void _moreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MoreOptions(noteInEditing, _autoSaver, saveNote);
      },
    );
  }*/
  void _moreMenu(BuildContext context) {
    FocusScope.of(context).requestFocus(
      FocusNode(),
    );
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            MoreOptionsMenu(
              note: noteInEditing,
              saveNote: saveNote,
              autoSaver: _autoSaver,
            ),
          ],
        );
      },
    );
  }

  void onPressed() {
    setState(() {
      // ignore: parameter_assignments
      isReadOnly = !isReadOnly;
    });
  }

/*void _onChanged(String value) {
    final counter = Provider.of<CharCount>(context, listen: false);
    counter.change(value.length);
  }*/
}

/*if (_image != null)
              Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: noteInEditing.imagePath,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: FileImage(_image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                oldName = _image.path;
                                _image = null;
                                updateNote();
                                deleteImage();
                              });
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),*/
