import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/database/note.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:provider/provider.dart';

import '../main.dart';

_TrashScreenHelperState trash;

class TrashScreenHelper extends StatefulWidget {
  @override
  _TrashScreenHelperState createState() => _TrashScreenHelperState();
}

class _TrashScreenHelperState extends State<TrashScreenHelper> {
  MyAppBar appbar;

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
    trash = this;
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
          title: 'Trash',
          imagePath: 'assets/images/img3.jpg',
        ),
        body: DoubleBackToCloseWidget(
          child: SafeArea(
            child: Body(
              fromWhere: NoteState.deleted,
            ),
          ),
        ),
        bottomSheet: _bottomBar(context),
      ),
    );
  }

  Widget _bottomBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: kBottomNavigationBarHeight,
        padding: EdgeInsets.symmetric(horizontal: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
            ),
            IconButton(
              onPressed: () {
                _moreOptions(context);
              },
              icon: Icon(Icons.more_vert_outlined),
              color: headerColor,
              tooltip: 'More ',
            ),
          ],
        ),
      ),
    );
  }

  void _moreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return _moreOptionsMenu(context);
      },
    );
  }

  Widget _moreOptionsMenu(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            deleteAllIcon(context),
          ],
        ),
      ),
    );
  }

  Widget deleteAllIcon(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.delete_forever_outlined,
        color: Colors.blue,
      ),
      title: Text('Delete all Notes'),
      onTap: () async {
        await Provider.of<NotesHelper>(this.context, listen: false)
            .deleteAllTrashNotes();
        Navigator.of(context).pop();
        String whereToNavigate = Utilities.navChecker(NoteState.deleted);
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            whereToNavigate, (Route<dynamic> route) => false);
      },
    );
  }
}
