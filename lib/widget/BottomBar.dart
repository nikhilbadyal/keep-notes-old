import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/Navigations.dart';
import 'package:permission_handler/permission_handler.dart';

Widget bottomBar(BuildContext context, NoteState noteState) {
  return BottomAppBar(
    shape: CircularNotchedRectangle(),
    child: Container(
      height: 60.0,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.camera_alt_outlined,
              size: 25,
              color: headerColor,
            ),
            onPressed: () async {
              var cameraStatus = await Permission.camera.status;
              if (cameraStatus.isGranted) {
                await pickImageAndGetNote(
                    context, noteState, ImageSource.camera);
              } else if (cameraStatus.isUndetermined) {
                cameraStatus = await Permission.camera.request();
              } else if (cameraStatus.isDenied) {
                cameraStatus = await Permission.camera.request();
              } else {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Storage Permission'),
                    content:
                        Text('This app needs storage access to store data.'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Deny'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      FlatButton(
                        child: Text('Settings'),
                        onPressed: () async {
                          await openAppSettings();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              }
            },
            tooltip: 'Camera',
          ),
          IconButton(
            icon: Icon(Icons.insert_photo, color: headerColor),
            onPressed: () async {
              var storageStatus = await Permission.storage.status;
              if (storageStatus.isGranted) {
                await pickImageAndGetNote(
                    context, noteState, ImageSource.gallery);
              } else if (storageStatus.isUndetermined) {
                storageStatus = await Permission.storage.request();
              } else if (storageStatus.isDenied) {
                storageStatus = await Permission.storage.request();
              } else {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Storage Permission'),
                    content:
                        Text('This app needs storage access to store data.'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Deny'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      FlatButton(
                        child: Text('Settings'),
                        onPressed: () async {
                          await openAppSettings();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              }
            },
            tooltip: 'Gallery',
          ),
        ],
      ),
    ),
  );
}

Future<void> pickImageAndGetNote(
    BuildContext context, NoteState noteState, ImageSource source) async {
  String imagePath;
  imagePath = await Utilities.getImage(source);
  goToNoteEditScreen(
      context: context,
      noteState: noteState,
      imagePath: imagePath,
      shouldAutoFocus: false);
}
