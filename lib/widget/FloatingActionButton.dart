import 'package:flutter/material.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/Navigations.dart';
import 'package:permission_handler/permission_handler.dart';

Widget fab(BuildContext context, NoteState noteState) {
  return FloatingActionButton(
    onPressed: () async {
      var storageStatus = await Permission.storage.status;
      if (storageStatus.isGranted) {
        goToNoteEditScreen(
            context: context, noteState: noteState, shouldAutoFocus: true);
      } else if (storageStatus.isUndetermined) {
        storageStatus = await Permission.storage.request();
      } else if (storageStatus.isDenied) {
        storageStatus = await Permission.storage.request();
      } else {
        AlertDialog(
          title: Text('App needs access to store data'),
          actions: [
            TextButton(
              child: Text('Deny'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Open Settings'),
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    },
    tooltip: 'Add Notes',
    child: Icon(Icons.add),
    foregroundColor: Colors.white,
    backgroundColor: headerColor,
  );
}
