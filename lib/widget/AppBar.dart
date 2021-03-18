import 'package:flutter/material.dart';
import 'package:notes/main.dart';

_MyAppBarState appBar;

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
  void callSetState() {
    setState(() {
      myNotes.drawerManager.isOpened = !myNotes.drawerManager.isOpened;
    });
  }

  @override
  Widget build(BuildContext context) {
    appBar = this;
    return AppBar(
      elevation: 0.6,
      leading: Leading(),
      title: Text("${widget.title}"),
      actions: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xffFDCF09),
          child: CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(widget.imagePath),
          ),
        ),
      ],
    );
  }

}

class Leading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (myNotes.drawerManager.isOpened) {
      return IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          myNotes.drawerManager.isOpened = false;
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
          myNotes.drawerManager.isOpened = true;
          myNotes.drawerManager.callback(false);
        },
      );
    }
  }
}
