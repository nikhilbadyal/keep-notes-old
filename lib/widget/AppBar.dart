import 'package:flutter/material.dart';
import 'package:notes/util/Utilites.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function callback;
  final String title;
  final String imagePath;

  MyAppBar(
      {Key key,
      @required this.callback,
      @required this.title,
      @required this.imagePath})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  final Size preferredSize;
}

class _MyAppBarState extends State<MyAppBar> {
  bool isClosed = true;

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
    if (isClosed) {
      return IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          isClosed = false;
          widget.callback(isClosed);
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          if (isClosed == false) {
            isClosed = true;
            widget.callback(isClosed);
          }
        },
      );
    }
  }

  Widget _title() {
    try {
      /*final Image titleImage = Image.asset(
        'assets/images/${widget.title}.png',
        fit: BoxFit.cover,
        height: 35,
        width: 40,
      );
      return titleImage;*/
      return Text("${widget.title}");
    } catch (_) {
      return Center(child: Text(widget.title));
    }
  }
}
