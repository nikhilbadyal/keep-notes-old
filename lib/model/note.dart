import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/app.dart';

enum NoteState {
  unspecified, //HOM
  pinned,
  archived, //ARCHIVED
  hidden, //HIdden
  deleted, //Trash
}

extension NoteStatex on NoteState {
  bool operator <(NoteState other) => (this?.index ?? 0) < (other.index ?? 0);

  bool operator <=(NoteState other) => (this?.index ?? 0) <= (other.index ?? 0);

  bool get canEdit => this < NoteState.deleted;
}

class Note {
  Note(
      {@required this.id,
      @required this.title,
      @required this.content,
      @required this.creationDate,
      @required this.lastModify,
      @required this.color,
      @required this.state,
      @required this.imagePath});

  int id;
  String title;
  String content;
  DateTime creationDate;
  DateTime lastModify;
  Color color;
  NoteState state;
  String imagePath;

  @override
  String toString() {
    return 'Object is $id $title $content $creationDate $lastModify $color $state $imagePath ';
  }

  Map<String, dynamic> toMap({bool isNew}) {
    final data = <String, dynamic>{
      'title': title,
      'content': content,
      'creationDate':
          creationDate.millisecondsSinceEpoch, //epochFromDate(creationDate),
      'lastModify': lastModify.millisecondsSinceEpoch,
      'color': color.value,
      'state': state.index, //  for later use for integrating archiving
      'imagePath': imagePath,
    };
    if (!isNew) {
      data['id'] = id;
    }
    return data;
  }

  void update(Note other, {bool updateTimestamp = true}) {
    title = other.title;
    content = other.content;
    color = other.color;
    state = other.state;
    imagePath = other.imagePath;

    if (updateTimestamp || other.lastModify == null) {
      lastModify = DateTime.now();
    } else {
      lastModify = other.lastModify;
    }
  }

  static Note fromJson(Map<String, dynamic> json) {
    int state = json['state'];
    if (state == 3 && !myNotes.lockChecker.passwordSet) {
      state = 0;
    }
    return Note(
        id: -1,
        title: json['title'].toString(),
        content: json['content'].toString(),
        creationDate: DateTime.fromMillisecondsSinceEpoch(
          json['creationDate'],
        ),
        lastModify: DateTime.fromMillisecondsSinceEpoch(
          json['lastModify'],
        ),
        color: Color(
          json['color'],
        ),
        state: NoteState.values[state],
        imagePath: null);
  }

  Map<String, dynamic> toJson() {
    final data = {
      'title': title,
      'content': content,
      'creationDate': creationDate.millisecondsSinceEpoch,
      'lastModify': lastModify.millisecondsSinceEpoch,
      'color': color.value,
      'state': state.index,
      'imagePath': null,
    };
    return data;
  }

  String get strLastModifiedDate =>
      DateFormat.yMd().add_jm().format(lastModify);

  String get strLastModifiedDate1 => DateFormat('jm').format(lastModify);
}
