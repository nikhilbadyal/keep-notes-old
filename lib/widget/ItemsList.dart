import 'package:flutter/material.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/screen/EditScreen.dart';
import 'package:notes/util/AppConfiguration.dart';

class ListItem extends StatelessWidget {
  const ListItem({Key key, @required this.note, @required this.fromWhere})
      : super(key: key);

  final Note note;
  final NoteState fromWhere;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110.0,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: GestureDetector(
        onLongPress: () {
          if (note.state == NoteState.deleted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const MySimpleDialog(
                  title: Text('Suggestion Needed'),
                  children: [
                    Text(
                        'I can\'t think of anything good to add here. Can you suggest ?'),
                  ],
                );
              },
            );
          }
        },
        onTap: () async {
          if (note.state == NoteState.deleted) {
            await showDialog<bool>(
              context: context,
              builder: (BuildContext context) => const MySimpleDialog(
                title: Text('Please remove note from trash before editing'),
              ),
            );
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => EditScreen(
                  currentNote: note,
                  fromWhere: fromWhere,
                  isImageNote: false,
                ),
              ),
            );
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: selectedAppTheme == AppTheme.Light
                ? Theme.of(context).floatingActionButtonTheme.foregroundColor
                : Colors.grey[900],
            // color: Utilities.whiteColor,
            boxShadow: selectedAppTheme == AppTheme.Light ? shadow : null,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: selectedAppTheme == AppTheme.Light
                  ? greyColor
                  : Theme.of(context).primaryColor,
              // color: Colors.white,
              // color: Utilities.greyColor,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        note.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        note.strLastModifiedDate,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.0,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Expanded(
                        child: Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
