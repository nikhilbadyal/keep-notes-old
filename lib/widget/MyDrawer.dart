import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/app.dart';
import 'package:notes/screen/SetPassword.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/widget/Navigations.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with RouteAware {
  String _activeRoute = '/';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
      this,
      ModalRoute.of(context),
    );
    // myRouteObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPop() {
    //debugPrint('You pooed some shit');
  }

  @override
  void didPush() {
    _activeRoute = ModalRoute.of(context).settings.name;
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint(_activeRoute+"old");

    _activeRoute ??= '/';
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/women2.jpg'),
            ),
            accountEmail: const Text('Nikhil'),
            accountName: const Text('nikhildevelops@gmail.com'),
            onDetailsPressed: () async {
              if (myNotes.lockChecker.passwordSet) {
                await navigate(_activeRoute, context, NotesRoutes.lockScreen);
              } else {
                await navigate(
                  _activeRoute,
                  context,
                  NotesRoutes.setpassScreen,
                  DataObj(true, '', 'Enter New Password'),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.note,
            ),
            title: const Text(
              'Notes',
            ),
            selected: _activeRoute == NotesRoutes.homeScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.homeScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.archive_outlined,
            ),
            title: const Text('Archive'),
            selected: _activeRoute == NotesRoutes.archiveScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.archiveScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_backup_restore,
            ),
            title: const Text('Backup and Restore'),
            selected: _activeRoute == NotesRoutes.backupScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.backupScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever_outlined,
            ),
            title: const Text('Deleted'),
            selected: _activeRoute == NotesRoutes.trashScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.trashScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.person_outline,
            ),
            title: const Text('About Me'),
            selected: _activeRoute == NotesRoutes.aboutMeScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.aboutMeScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: const Text('Settings'),
            selected: _activeRoute == NotesRoutes.settingsScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.settingsScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.email_outlined,
            ),
            title: const Text('Report/Suggest'),
            selected: _activeRoute == NotesRoutes.suggestScreen,
            onTap: () => goToBugScreen(context),
          ),
          /* AboutListTile(
            icon: Icon(Icons.info, color: Utilities.iconColor(),),
            applicationName: 'Notes App',
            aboutBoxChildren: const <Widget>[
              Text('Thanks for trying this app.'),
            ],
          ),*/
        ],
      ),
    );
  }
}
