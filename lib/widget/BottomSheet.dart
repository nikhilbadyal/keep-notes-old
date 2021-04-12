import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:notes/screen/ModalSheetWidgets.dart';
import 'package:notes/util/Utilites.dart';

class MyBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                moreOptions(context);
              },
              icon: const Icon(Icons.more_vert_outlined),
              color: Utilities.iconColor(),
              tooltip: 'More ',
            ),
          ],
        ),
      ),
    );
  }
}

void moreOptions(BuildContext context) {
  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    context: context,
    builder: (context) {
      return Wrap(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(EvaIcons.arrowBackOutline),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 16),
                const Text('Options'),
              ],
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            children: const [
              ModalSheetDeleteAllWidget(),
            ],
          ),
        ],
      );
    },
  );
}
/*
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
    leading: Icon(
      Icons.delete_forever_outlined,
      color: Utilities.iconColor(),
    ),
    title: const Text('Delete all Notes'),
    onTap: () async {
      await Provider.of<NotesHelper>(context, listen: false)
          .deleteAllTrashNotes();
      Navigator.of(context).pop();
      await navigate('', context, NotesRoutes.trashScreen);
    },
  );
}*/
