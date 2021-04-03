import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Navigations.dart';

class ThirdLayer extends StatelessWidget {
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
                        // appBar.drawerNotifier.value = true;
                        appBar.drawerNotifier.value = true;
                      } else {
                        var status = myNotes.lockChecker.passwordSet;
                        print(status);
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
                      const Text(
                        'Nik',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'hil',
                        style: const TextStyle(
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
                        appBar.drawerNotifier.value = true;
                      } else {
                        goToHomeScreen(context);
                      }
                    },
                    child: const Text(
                      'Notes',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (ModalRoute.of(context).settings.name == '/archive') {
                        myNotes.drawerManager.closeDrawer();
                        appBar.drawerNotifier.value = true;
                      } else {
                        goToArchiveScreen(context);
                      }
                    },
                    child: const Text(
                      'Archive',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (ModalRoute.of(context).settings.name == '/backup') {
                        myNotes.drawerManager.closeDrawer();
                        appBar.drawerNotifier.value = true;
                      } else {
                        goToBackUpScreen(context);
                      }
                    },
                    child: const Text(
                      'Backup and Restore',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (ModalRoute.of(context).settings.name == '/trash') {
                        myNotes.drawerManager.closeDrawer();
                        appBar.drawerNotifier.value = true;
                      } else {
                        goToDeleteScreen(context);
                      }
                    },
                    child: const Text(
                      'Deleted',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (ModalRoute.of(context).settings.name == '/about') {
                        myNotes.drawerManager.closeDrawer();
                        appBar.drawerNotifier.value = true;
                      } else {
                        goToAboutMeScreen(context);
                      }
                    },
                    child: const Text(
                      'About Me',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (ModalRoute.of(context).settings.name == '/settings') {
                        myNotes.drawerManager.closeDrawer();
                        appBar.drawerNotifier.value = true;
                      } else {
                        goToSettingsScreen(context);
                      }
                    },
                    child: const Text(
                      'Settings',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      goToBugScreen(context);
                    },
                    child: const Text(
                      'Report/Suggest',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
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
                              myNotes.drawerManager.callback(true);
                              appBar.drawerNotifier.value = true;
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

  const ThirdLayer();
}
