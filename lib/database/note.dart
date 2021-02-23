import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum NoteState {
  unspecified, //unarchive
  pinned,
  archived,
  hidden,
  deleted,
}

extension NoteStatex on NoteState {
  bool operator <(NoteState other) => (this?.index ?? 0) < (other.index ?? 0);

  bool operator <=(NoteState other) => (this?.index ?? 0) <= (other.index ?? 0);

  bool get canEdit => this < NoteState.deleted;
}

class Note {
  int id;
  String title;
  String content;
  DateTime creationDate;
  DateTime lastModify;
  Color color;
  NoteState state;
  String imagePath;

  /*Note(this.id, this.title, this.content, this.creationDate, this.lastModify,
      this.color, this.state, this.imagePath);*/

  Note(
      {@required this.id,
      @required this.title,
      @required this.content,
      @required this.creationDate,
      @required this.lastModify,
      @required this.color,
      @required this.state,
      @required this.imagePath}) {}

  @override
  String toString() {
    return 'Object is $id $title $content $creationDate $lastModify $color $state $imagePath ';
  }

  Map<String, dynamic> toMap(bool isNew) {
    debugPrint(content);
    Map<String, dynamic> data = {
      'title': title,
      'content': content,
      'creationDate':
          creationDate.millisecondsSinceEpoch, //epochFromDate(creationDate),
      'lastModify': lastModify.millisecondsSinceEpoch,
      'color': color.value,
      'state': state.index, //  for later use for integrating archiving
      'imagePath': imagePath,
    };

    if (id != -1) {
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
    //   notifyListeners();
  }

  Note fromJson(Map<String, dynamic> json) {
    return Note(
        id: json['id'],
        title: json['title'].toString(),
        content: json['content'].toString(),
        creationDate: DateTime.fromMillisecondsSinceEpoch(json['creationDate']),
        lastModify: DateTime.fromMillisecondsSinceEpoch(json['lastModify']),
        color: Color(json['color']),
        state: NoteState.values[json['state']],
        imagePath: null);
  }

  Map<String, dynamic> toJson() {
    var data = {
      'title': title,
      'content': content,
      'creationDate':
          creationDate.millisecondsSinceEpoch, //epochFromDate(creationDate),
      'lastModify': lastModify.millisecondsSinceEpoch,
      'color': color.value,
      'state': state.index, //  for later use for integrating archiving
      'imagePath': null,
    };
    data['id'] = id;
    return data;
  }

  String get strLastModifiedDate =>
      DateFormat.yMd().add_jm().format(lastModify);

  String get strLastModifiedDate1 => DateFormat('jm').format(lastModify);
}
