import 'package:flutter/material.dart';
import 'package:notes/main.dart';

_MyAppBarState appBar;

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  MyAppBar({Key key, @required @required this.title})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  final Size preferredSize;
}

class _MyAppBarState extends State<MyAppBar> {
  final drawerNotifier = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    appBar = this;
    debugPrint('Building app bar');
    return AppBar(
      elevation: 0.6,
      leading: Leading(),
      title: Text("${widget.title}"),
      actions: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xffFDCF09),
          child: const CircleAvatar(
            radius: 22,
            backgroundImage: const AssetImage("assets/images/img3.jpg"),
          ),
        ),
      ],
    );
  }
}

class Leading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('building app bar icon 14');
    return IconButton(
      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
      onPressed: () {
        myNotes.drawerManager.callback(true);
        appBar.drawerNotifier.value = true;
      },
    );
  }

  const Leading();
}
