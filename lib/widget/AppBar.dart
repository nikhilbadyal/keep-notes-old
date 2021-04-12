import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({Key key, @required this.title, this.appBarWidget})
      : super(key: key);

  final Widget title;
  final Widget appBarWidget;

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.6,
      title: widget.title,
      actions: [
        widget.appBarWidget ?? AppBarAvatar(),
      ],
    );
  }
}

class AppBarAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 25,
      // backgroundColor: Utilities.appBarAvatarColor,
      child: CircleAvatar(
        radius: 22,
        backgroundImage: AssetImage('assets/images/women2.jpg'),
      ),
    );
  }
}
