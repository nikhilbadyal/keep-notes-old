import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/views/ScreenHelpers/NoteEditScreen.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: InkWell(
        onTap: () async {
          if (note.state == NoteState.deleted) {
            await showDialog<bool>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title:
                    const Text('Please remove note from trash before editing'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Ok'),
                  ),
                ],
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
            color: white,
            boxShadow: shadow,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: grey,
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
                          fontSize: 18.0,
                          color: black,
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
                          color: grey2,
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
                            color: grey2,
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
