import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/BottomBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/FloatingActionButton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

_BackUpScreenHelperState backup;

class BackUpScreenHelper extends StatefulWidget {
  @override
  _BackUpScreenHelperState createState() => _BackUpScreenHelperState();
}

class _BackUpScreenHelperState extends State<BackUpScreenHelper>
    with TickerProviderStateMixin {
  AnimationController _xController;
  AnimationController _yController;
  AnimationController _angleController;

  @override
  void initState() {
    _xController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 150,
    );
    _yController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 80,
    );
    _angleController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 0.2,
    );
    super.initState();
  }

  animate() {
    if (_xController.isCompleted) {
      _xController.reverse();
      _yController.reverse();
      _angleController.reverse();
    } else {
      _xController.forward(from: 0);
      _yController.forward(from: 0);
      _angleController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _angleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('building 7');
    backup = this;
    return AnimatedBuilder(
      animation: _xController,
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4Transform()
              .translate(x: _xController.value, y: _yController.value)
              .rotate(-_angleController.value)
              .matrix4,
          child: child,
        );
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: "Backup&Restore",
        ),
        body: DoubleBackToCloseWidget(
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          List<Note> items = await Provider.of<NotesHelper>(
                                  context,
                                  listen: false)
                              .getNotesAllForBackup();
                          await exportToFile(items);
                          Utilities.showSnackbar(context, "Notes Exported",
                              Colors.white, Duration(seconds: 2), Colors.green);
                        },
                        child: const Text('Export Notes'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (await Utilities.requestPermission(
                              Permission.storage)) {
                            FilePickerResult result = await FilePicker.platform
                                .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ["json"]);
                            File file;
                            if (result != null) {
                              file = File(result.files.single.path);
                            } else {}
                            importFromFile(file);
                          } else {
                            Utilities.showSnackbar(
                                context,
                                "Permission Not granted",
                                Colors.white,
                                Duration(seconds: 2),
                                Colors.green);
                          }
                        },
                        child: const Text('Import Notes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Fab(NoteState.archived),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }

  Future<void> exportToFile(List<Note> items) async {
    Directory directory;
    try {
      if (await Utilities.requestPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        String newPath = "";
        List<String> paths = directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/NotesApp";
        directory = Directory(newPath);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        String str = DateFormat("yyyyMMdd_HHmmss").format(
          DateTime.now(),
        );
        var file = "notesExport_${str}.json";
        File filePath = File(directory.path + "/$file");
        items.sort(
          (a, b) => a.lastModify.compareTo(b.lastModify),
        );
        List jsonList = [];
        items.forEach(
          (element) => jsonList.add(json.encode(
            element.toJson(),
          )),
        );
        filePath.writeAsStringSync(
          jsonList.toString(),
        );
      }
    } catch (e) {
      Utilities.showSnackbar(context, "Error while exporting", Colors.white,
          Duration(seconds: 2), Colors.green);
    }
  }

  Future<void> importFromFile(File file) async {
    try {
      var StringContent = file.readAsStringSync();
      List jsonList = json.decode(StringContent);
      List<Note> notesList = jsonList
          .map(
            (json) => Note.fromJson(json),
          )
          .toList();
      await Provider.of<NotesHelper>(context, listen: false)
          .addAllNotesToBackup(notesList);
      Utilities.showSnackbar(context, "Done importing", Colors.white,
          Duration(seconds: 2), Colors.green);
    } catch (e) {
      Utilities.showSnackbar(context, "Error while importing", Colors.white,
          Duration(seconds: 2), Colors.redAccent);
    }
  }
}
