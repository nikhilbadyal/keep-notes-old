import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/Navigations.dart';

import '../main.dart';

_SuggestionsScreenHelperState suggestion;

class SuggestionsScreenHelper extends StatefulWidget {
  @override
  _SuggestionsScreenHelperState createState() =>
      _SuggestionsScreenHelperState();
}

class _SuggestionsScreenHelperState extends State<SuggestionsScreenHelper> {
  MyAppBar appbar;
  Widget currentPage;

  @override
  void initState() {
    super.initState();
    appbar = MyAppBar(
      title: 'Notes',
      imagePath: 'assets/images/img3.jpg',
    );
  }

  void callSetState() {
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    suggestion = this;
    return AnimatedContainer(
      transform: Matrix4Transform()
          .translate(
              x: myNotes.drawerManager.xOffSet,
              y: myNotes.drawerManager.yOffSet)
          .rotate(myNotes.drawerManager.angle)
          .matrix4,
      duration: Duration(milliseconds: 250),
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Suggestions',
          imagePath: 'assets/images/img3.jpg',
        ),
        body: DoubleBackToCloseWidget(
          child: Center(
            child: AlertDialog(
              title: Text('Screen not implemented yet'),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    goTOHomeScreen(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
