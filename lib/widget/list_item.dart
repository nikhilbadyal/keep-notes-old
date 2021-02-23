import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/ScreenHelpers/NoteEditScreen.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/constants.dart';

import 'PopUp.dart';

class ListItem extends StatelessWidget {
  final Note note;
  final NoteState fromWhere;

  const ListItem({Key key, this.note, this.fromWhere}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 135.0,
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          if (note.state == NoteState.deleted) {
            PopUp(context);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditScreen(
                          currentNote: note,
                          shouldAutoFocus: true,
                          fromWhere: fromWhere,
                          isImageNote: false,
                        )));
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: white,
            boxShadow: shadow,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: grey,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        note.strLastModifiedDate,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.0,
                          color: grey2,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Expanded(
                        child: Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: grey2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (note.imagePath.isNotEmpty)
                Row(
                  children: [
                    SizedBox(
                      width: 12.0,
                    ),
                    Container(
                      width: 80.0,
                      height: 95.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: FileImage(
                            File(note.imagePath),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> errorPopUp(BuildContext context, String data) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(data),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }

  Future<void> PopUp(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Error',
        descriptions: 'Please remove note from trash before editing',
        firstOption: 'Ok',
        secondOption: '',
        onFirstPressed: () {
          Navigator.of(context).pop(true);
        },
        onSecondPressed: () {},
      ),
    );
  }
}
