import 'package:flutter/material.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Navigations.dart';
import 'package:provider/provider.dart';

import '../../app.dart';

class ThirdLayer extends StatelessWidget {
  const ThirdLayer();

  @override
  Widget build(BuildContext context) {
    debugPrint('drawer building 1 ');
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      //TODO detect current screen
                      /*if (ModalRoute.of(context).settings.name == '/hidden') {
                        myNotes.drawerManager.closeDrawer(context);
                        // appBar.drawerNotifier.value = true;
                      } else {*/
                      final status = myNotes.lockChecker.passwordSet;
                      //print(status);
                      if (status) {
                        await goToLockScreen(context);
                      } else {
                        await goToSetPasswordScreen(context);
                      }
                      // }
                    },
                    child: FlutterLogo(
                      size: MediaQuery.of(context).size.width / 4,
                    ),
                  ),
                  Row(
                    children: const <Widget>[
                      Text(
                        'Nik',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'hil',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      /*if (ModalRoute.of(context).settings.name == '/') {
                        myNotes.drawerManager.closeDrawer(context);
                      } else {*/
                      goToHomeScreen(context);
                      // }
                    },
                    child: const Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      /* if (ModalRoute.of(context).settings.name == '/archive') {
                        myNotes.drawerManager.closeDrawer(context);
                      } else {*/
                      goToArchiveScreen(context);
                      // }
                    },
                    child: const Text(
                      'Archive',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      /* if (ModalRoute.of(context).settings.name == '/backup') {
                        myNotes.drawerManager.closeDrawer(context);
                      } else {*/
                      goToBackUpScreen(context);
                      // }
                    },
                    child: const Text(
                      'Backup and Restore',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      /* if (ModalRoute.of(context).settings.name == '/trash') {
                        myNotes.drawerManager.closeDrawer(context);
                      } else {*/
                      goToDeleteScreen(context);
                      // }
                    },
                    child: const Text(
                      'Deleted',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      /*if (ModalRoute.of(context).settings.name == '/about') {
                        myNotes.drawerManager.closeDrawer(context);
                      } else {*/
                      goToAboutMeScreen(context);
                      // }
                    },
                    child: const Text(
                      'About Me',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      /*if (ModalRoute.of(context).settings.name == '/settings') {
                        myNotes.drawerManager.closeDrawer(context);
                      } else {*/
                      goToSettingsScreen(context);
                      // }
                    },
                    child: const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      goToBugScreen(context);
                    },
                    child: const Text(
                      'Report/Suggest',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Semantics(
                          label: 'Close Drawer',
                          button: true,
                          enabled: true,
                          excludeSemantics: true,
                          child: FloatingActionButton.extended(
                            heroTag: UniqueKey(),
                            key: const ValueKey('Back'),
                            onPressed: () {
                              final status = Provider.of<AppbarStatus>(context,
                                  listen: false);
                              status.toggle();
                              leadingState.reverse();
                              myNotes.drawerManager.callback(
                                  context, myNotes.drawerManager.isOpened);
                            },
                            icon: IconTheme(
                              data: IconThemeData(color: colorScheme.onPrimary),
                              child: const BackButtonIcon(),
                            ),
                            label: Text(
                              MaterialLocalizations.of(context)
                                  .backButtonTooltip,
                              style: textTheme.button
                                  .apply(color: colorScheme.onPrimary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
