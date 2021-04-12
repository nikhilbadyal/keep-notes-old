import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/Utilites.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BackUpScreenHelper extends StatefulWidget {
  const BackUpScreenHelper();

  @override
  _BackUpScreenHelperState createState() => _BackUpScreenHelperState();
}

class _BackUpScreenHelperState extends State<BackUpScreenHelper>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    //debugPrint('building 7');
    return Container(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  final items =
                      await Provider.of<NotesHelper>(context, listen: false)
                          .getNotesAllForBackup();
                  await exportToFile(items);
                  Utilities.showSnackbar(
                    context,
                    'Notes Exported',
                    const Duration(seconds: 2),
                  );
                },
                child: const Text(
                  'Export Notes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await Utilities.requestPermission(Permission.storage)) {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['json'],
                    );
                    File file;
                    if (result != null) {
                      file = File(result.files.single.path);
                    } else {}
                    await importFromFile(file);
                  } else {
                    Utilities.showSnackbar(
                      context,
                      'Permission Not granted',
                      const Duration(seconds: 2),
                    );
                  }
                },
                child: const Text(
                  'Import Notes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> exportToFile(List<Note> items) async {
    Directory directory;
    try {
      if (await Utilities.requestPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        var newPath = '';
        final paths = directory.path.split('/');
        for (var x = 1; x < paths.length; x++) {
          final folder = paths[x];
          if (folder != 'Android') {
            newPath += '/$folder';
          } else {
            break;
          }
        }
        newPath = '$newPath/NotesApp';
        directory = Directory(newPath);
        if (!directory.existsSync()) {
          await directory.create(recursive: true);
        }
        final str = DateFormat('yyyyMMdd_HHmmss').format(
          DateTime.now(),
        );
        final file = 'notesExport_$str.json';
        final filePath = File('${directory.path}${'/$file'}');
        items.sort(
          (a, b) => a.lastModify.compareTo(b.lastModify),
        );
        final jsonList = [];
        for (final note in items) {
          jsonList.add(json.encode(note.toJson()));
        }
        filePath.writeAsStringSync(
          jsonList.toString(),
        );
      }
    } catch (e) {
      Utilities.showSnackbar(
        context,
        'Error while exporting',
        const Duration(seconds: 2),
      );
    }
  }

  Future<void> importFromFile(File file) async {
    try {
      final stringContent = file.readAsStringSync();
      final List jsonList = json.decode(stringContent);
      final notesList = jsonList
          .map(
            (json) => Note.fromJson(json),
          )
          .toList();
      await Provider.of<NotesHelper>(context, listen: false)
          .addAllNotesToBackup(notesList);
      Utilities.showSnackbar(
        context,
        'Done importing',
        const Duration(seconds: 2),
      );
    } catch (e) {
      Utilities.showSnackbar(
        context,
        'Error while importing',
        const Duration(seconds: 2),
      );
    }
  }
}
