import 'package:flutter/material.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:provider/provider.dart';

import '../app.dart';

_MyAppBarState appBar;

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({Key key, @required @required this.title})
      : preferredSize = const Size.fromHeight(60.0),
        super(key: key);

  final String title;

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  final Size preferredSize;
}

class AppbarStatus with ChangeNotifier {
  bool isOpened = false;

  void toggle() {
    isOpened = !isOpened;
    notifyListeners();
  }
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    appBar = this;
    //debugPrint('Building app bar');
    return AppBar(
      elevation: 0.6,
      leading: Consumer<AppbarStatus>(builder: (_, __, ___) {
        return Leading();
      }),
      title: Text(widget.title),
      actions: const [
        CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xffFDCF09),
          child: CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/img3.jpg'),
          ),
        ),
      ],
    );
  }
}

_LeadingState leadingState;

class Leading extends StatefulWidget {
  @override
  _LeadingState createState() => _LeadingState();
}

class _LeadingState extends State<Leading> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      reverseDuration: Duration(milliseconds: DrawerManager.animationTime),
    );
    super.initState();
  }

  void reverse() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    leadingState = this;
    // print('building app bar');
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: _controller,
      ),
      onPressed: () {
        final status = Provider.of<AppbarStatus>(context, listen: false);
        // setState(() {
        // print(status.isOpened);
        status.isOpened ? _controller.reverse() : _controller.forward();
        status.toggle();
        // Provider.of<AppbarStatus>(context,listen:  false).toggle();
        // });
        myNotes.drawerManager.callback(context, myNotes.drawerManager.isOpened);
      },
    );
  }
}
