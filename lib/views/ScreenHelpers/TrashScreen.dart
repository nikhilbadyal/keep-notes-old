import 'package:flutter/material.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/Navigations.dart';
import 'package:provider/provider.dart';

class TrashScreenHelper extends StatefulWidget {
  @override
  _TrashScreenHelperState createState() => _TrashScreenHelperState();
}

class _TrashScreenHelperState extends State<TrashScreenHelper>
    with TickerProviderStateMixin {
  Note note;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 12');
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Trash',
      ),
      body: DoubleBackToCloseWidget(
        child: SafeArea(
          child: Body(
            fromWhere: NoteState.deleted,
            primary: primary,
            secondary: secondary,
          ),
        ),
      ),
      bottomSheet: _bottomBar(context),
    );
  }

  List<Widget> secondary(Note note) {
    final actionList = <Widget>[];
    actionList.add(Utilities.deleteAction(context, note));
    return actionList;
  }

  List<Widget> primary(Note note) {
    final actionList = <Widget>[];
    actionList.add(Utilities.restoreAction(context, note));
    return actionList;
  }

  Widget _bottomBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: kBottomNavigationBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 1),
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
              icon: const Icon(Icons.more_vert_outlined),
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          deleteAllIcon(context),
        ],
      ),
    );
  }

  Widget deleteAllIcon(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.delete_forever_outlined,
        color: Colors.blue,
      ),
      title: const Text('Delete all Notes'),
      onTap: () async {
        await Provider.of<NotesHelper>(this.context, listen: false)
            .deleteAllTrashNotes();
        Navigator.of(context).pop();
        // String whereToNavigate = Utilities.navChecker(NoteState.deleted);
        await goToDeleteScreen(context);
        /*await Navigator.of(this.context).pushNamedAndRemoveUntil(
            whereToNavigate, (Route<dynamic> route) => false);*/
      },
    );
  }
}
