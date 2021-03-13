import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/DeletePopUp.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../main.dart';

// ignore: must_be_immutable
class EditScreen extends StatefulWidget {
  final Note currentNote;
  final bool shouldAutoFocus;
  bool isImageNote; //TODO fix this and make this final
  final NoteState fromWhere;

  EditScreen(
      {this.currentNote,
      this.shouldAutoFocus = true,
      @required this.fromWhere,
      @required this.isImageNote});

  @override
  _EditScreenState createState() => _EditScreenState();
}

//TODO something with delete pop up
class _EditScreenState extends State<EditScreen> {
  @override
  void initState() {
    super.initState();
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
    _autoSaver = Timer.periodic(Duration(seconds: 5), (timer) {
      saveNote();
    });
  }

  bool isNewNote;
  Note noteInEditing;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  var noteColor;
  bool isNew = false;
  var state;
  File _image;

  String _titleFromInitial;
  String _contentFromInitial;
  String _imagePathFromInitial;
  String oldName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (noteInEditing.imagePath != '') {
      _image = File(noteInEditing.imagePath);
    } else {
      _image = null;
    }
  }

  Timer _autoSaver;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: _appbar(context),
        body: _body(context),
        bottomSheet: _bottomBar(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
                child: TextField(
                  controller: _titleController,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  decoration: InputDecoration(
                      hintText: 'Enter Note Title', border: InputBorder.none),
                ),
              ),
            ),
            if (_image != null)
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                child: Stack(
                  children: [
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
                        padding: EdgeInsets.all(12.0),
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                oldName = _image.path;
                                _image = null; //TODO
                                updateNote();
                                deleteImage();
                              });
                            },
                            child: Icon(
                              Icons.delete_outline,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
                child: TextField(
                  autofocus: widget.shouldAutoFocus,
                  controller: _contentController,
                  maxLines: null,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  decoration: InputDecoration(
                      hintText: 'Enter Content', border: InputBorder.none),
                ),
              ),
            ),
          ],
        ),
        left: true,
        right: true,
        top: false,
        bottom: false,
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
    if (await File(oldName).exists()) {
      await File(oldName).delete();
    } else {}
  }

  List<Widget> _appbarAction(BuildContext context) {
    return [
      //TODO add archive and unarchive
      if (noteInEditing.state != NoteState.deleted)
        IconButton(
          onPressed: () {
            _showDialog(context, noteInEditing, widget.fromWhere);
          },
          icon: Icon(Icons.delete_outline),
          tooltip: 'Delete Note',
        ),
    ];
  }

  Widget _bottomBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: kBottomNavigationBarHeight,
        padding: EdgeInsets.symmetric(horizontal: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
            ),
            Center(
                child: Text('Modified ${noteInEditing.strLastModifiedDate1}')),
            IconButton(
              onPressed: () {
                _moreMenu(context);
              },
              icon: Icon(Icons.more_vert_outlined),
              color: headerColor,
              tooltip: 'More ',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPress() async {
    _autoSaver.cancel();
    saveNote();
    Navigator.of(this.context).pop();
    return true;
  }

  void saveNote() {
    var isEdited = updateNote();
    var isEmptyNote = isEmpty();
    //TODO implement
    if (isEdited) {
      if (noteInEditing.id == -1) {
        if (!isEmptyNote) {
          var noteIn = Provider.of<NotesHelper>(this.context, listen: false)
              .insertNote(noteInEditing, true);
          noteIn.then((value) => noteInEditing = value);
        }
      } else {
        if (isEmptyNote) {
          Provider.of<NotesHelper>(this.context, listen: false)
              .deleteNote(noteInEditing);
        } else {
          var noteIn = Provider.of<NotesHelper>(this.context, listen: false)
              .insertNote(noteInEditing, false);
          noteIn.then((value) => noteInEditing = value);
        }
      }
      // TODO show snackbar if saved.
      return;
    }
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
    noteInEditing.imagePath = (_image != null ? _image.path : '');
    noteInEditing.color = noteColor;

    if (widget.isImageNote) {
      noteInEditing.lastModify = DateTime.now();
      widget.isImageNote = false;
      return true;
    }
    if (isNew &&
        !(noteInEditing.title == _titleFromInitial &&
            noteInEditing.content == _contentFromInitial &&
            noteInEditing.imagePath == _imagePathFromInitial)) {
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

  void _showDialog(BuildContext context, Note note, NoteState fromWhere) {
    showDialog(
        context: context,
        builder: (context) {
          return DeletePopUp(note, _autoSaver, fromWhere);
        });
  }

  void exitWithoutSaving(BuildContext context) {
    _autoSaver.cancel();
    Navigator.pop(context);
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: _onBackPress,
        color: Colors.white,
      ),
      backgroundColor: headerColor,
      actions: _appbarAction(context),
      elevation: 1,
    );
  }

  void _moreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return moreOption(context, noteInEditing, _autoSaver);
      },
    );
  }

  Future<void> getImage(ImageSource imageSource) async {
    var imageFile = await picker.getImage(source: imageSource);

    if (imageFile == null) {
      return;
    }
    _image = File(imageFile.path);
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);

    _image = await _image.copy('${appDir.path}/$fileName');
    setState(() {
      noteInEditing.imagePath = _image.path;
    });
  }

  Widget moreOption(BuildContext context, Note noteInEditing, Timer autoSaver) {
    //TODO optimize this
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          noteInEditing.state != NoteState.hidden
              ? ListTile(
                  leading: Icon(
                    TablerIcons.ghost,
                    color: Colors.blue,
                  ),
                  title: Text('Hide Note'),
                  onTap: () async {
                    if (myNotes.lockChecker.passwordSet) {
                      _autoSaver.cancel();
                      saveNote();
                      Provider.of<NotesHelper>(this.context, listen: false)
                          .hideNote(noteInEditing);
                      if (noteInEditing.state == NoteState.archived) {
                        Navigator.of(this.context).pushNamedAndRemoveUntil(
                            '/archive', (Route<dynamic> route) => false);
                      } else if (noteInEditing.state == NoteState.unspecified) {
                        Navigator.of(this.context).pushNamedAndRemoveUntil(
                            '/', (Route<dynamic> route) => false);
                      } else if (noteInEditing.state == NoteState.hidden) {
                        Navigator.of(this.context).pushNamedAndRemoveUntil(
                            '/hidden', (Route<dynamic> route) => false);
                      }
                    }
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("Please set password first"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(this.context)
                                        .pushNamedAndRemoveUntil('/setpass',
                                            (Route<dynamic> route) => false);
                                  },
                                  child: Text("Ok")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text("Later")),
                            ],
                          );
                        });
                  },
                )
              : ListTile(
                  leading: Icon(
                    Icons.inbox_outlined,
                    color: Colors.blue,
                  ),
                  title: Text('Unhide Note'),
                  onTap: () {
                    _autoSaver.cancel();
                    saveNote();
                    Provider.of<NotesHelper>(this.context, listen: false)
                        .unhideNote(noteInEditing);
                    if (noteInEditing.state == NoteState.archived) {
                      Navigator.of(this.context).pushNamedAndRemoveUntil(
                          '/archive', (Route<dynamic> route) => false);
                    } else if (noteInEditing.state == NoteState.unspecified) {
                      Navigator.of(this.context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    } else if (noteInEditing.state == NoteState.hidden) {
                      Navigator.of(this.context).pushNamedAndRemoveUntil(
                          '/hidden', (Route<dynamic> route) => false);
                    }
                  },
                ),
          ListTile(
            leading: Icon(
              Icons.archive,
              color: Colors.blue,
            ),
            title: Text('Archive Note'),
            onTap: () {
              _autoSaver.cancel();
              saveNote();
              Provider.of<NotesHelper>(this.context, listen: false)
                  .archiveNote(noteInEditing);
              if (noteInEditing.state == NoteState.archived) {
                Navigator.of(this.context).pushNamedAndRemoveUntil(
                    '/archive', (Route<dynamic> route) => false);
              } else if (noteInEditing.state == NoteState.unspecified) {
                Navigator.of(this.context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              } else if (noteInEditing.state == NoteState.hidden) {
                Navigator.of(this.context).pushNamedAndRemoveUntil(
                    '/hidden', (Route<dynamic> route) => false);
              }
            },
          ),
          ListTile(
            leading: Icon(
              TablerIcons.copy,
              color: Colors.blue,
            ),
            title: Text('Copy Note'),
            onTap: () {
              _autoSaver.cancel();
              saveNote();
              Provider.of<NotesHelper>(this.context, listen: false)
                  .copyNote(noteInEditing);
              if (noteInEditing.state == NoteState.archived) {
                Navigator.of(this.context).pushNamedAndRemoveUntil(
                    '/archive', (Route<dynamic> route) => false);
              } else if (noteInEditing.state == NoteState.unspecified) {
                Navigator.of(this.context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              } else if (noteInEditing.state == NoteState.hidden) {
                Navigator.of(this.context).pushNamedAndRemoveUntil(
                    '/hidden', (Route<dynamic> route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
