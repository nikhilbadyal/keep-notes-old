import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/util/Utilites.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String imagePath;

  MyAppBar({Key key, @required this.title, @required this.imagePath})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  final Size preferredSize;
}

class _MyAppBarState extends State<MyAppBar> {
  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.6,
      leading: _leading(),
      title: _title(),
      actions: [
        GestureDetector(
          onTap: () {
            Utilities.showMyToast('Hey Idiot 🥱', 1);
          },
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xffFDCF09),
            child: CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(widget.imagePath),
            ),
          ),
        ),
      ],
    );
  }

  Widget _leading() {
    if (isOpened) {
      return IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          isOpened = false;
          myNotes.drawerManager.callback(true);
        },
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          isOpened = true;
          myNotes.drawerManager.callback(false);
        },
      );
    }
  }

  Widget _title() {
    try {
      return Text("${widget.title}");
    } catch (_) {
      return Center(child: Text(widget.title));
    }
  }
}
