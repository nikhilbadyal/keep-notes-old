import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/widget/Navigations.dart';

class ThirdLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (ModalRoute.of(context).settings.name == '/hidden') {
                        myNotes.drawerManager.closeDrawer();
                      } else {
                        var status = myNotes.lockChecker.passwordSet;
                        if (status) {
                          await goToLockScreen(context);
                        } else {
                          goToSetPasswordScreen(context);
                        }
                      }
                    },
                    child: FlutterLogo(
                      size: MediaQuery.of(context).size.width / 4,
                    ),
                  ),
                  Row(
                    children: [
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
                children: [
                  GestureDetector(
                    onTap: () {
                      if (ModalRoute.of(context).settings.name == '/') {
                        myNotes.drawerManager.closeDrawer();
                      } else {
                        goTOHomeScreen(context);
                      }
                    },
                    child: Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (ModalRoute.of(context).settings.name == '/archive') {
                        myNotes.drawerManager.closeDrawer();
                      } else {
                        goTOArchiveScreen(context);
                      }
                    },
                    child: Text(
                      'Archive',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (ModalRoute.of(context).settings.name == '/backup') {
                        myNotes.drawerManager.closeDrawer();
                      } else {
                        goToBackUpScreen(context);
                      }
                    },
                    child: Text(
                      'Backup and Restore',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (ModalRoute.of(context).settings.name == '/trash') {
                        myNotes.drawerManager.closeDrawer();
                      } else {
                        goTODeleteScreen(context);
                      }
                    },
                    child: Text(
                      'Deleted',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (ModalRoute.of(context).settings.name == '/about') {
                        myNotes.drawerManager.closeDrawer();
                      } else {
                        goTOAboutMeScreen(context);
                      }
                    },
                    child: Text(
                      'About Me',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      goTOBugScreen(context);
                    },
                    child: Text(
                      'Report/Suggest',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Semantics(
                          label: "Close Drawer",
                          button: true,
                          enabled: true,
                          excludeSemantics: true,
                          child: FloatingActionButton.extended(
                            heroTag: UniqueKey(),
                            key: const ValueKey('Back'),
                            onPressed: () {
                              myNotes.drawerManager.isOpened = false;
                              myNotes.drawerManager.closeDrawer();
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
