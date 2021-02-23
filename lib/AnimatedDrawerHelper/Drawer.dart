import 'package:flutter/material.dart';
import 'package:notes/screens/LockScreen.dart';
import 'package:notes/widget/Navigations.dart';

class ThirdLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    //TODO ask for long tap or tap
                    onTap: () async {
                      if (ModalRoute.of(context).settings.name != '/hidden') {
                        var status = LockChecker.passwordSet;
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (ModalRoute.of(context).settings.name != '/') {
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
                    if (ModalRoute.of(context).settings.name != '/archive') {
                      goTOArchiveScreen(context);
                    }
                    //TODO implement this
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
                    //TODO
                    if (ModalRoute.of(context).settings.name != '/backup') {
                      goToBackUpScreen(context);
                    }
                    //TODO implement this
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
                    if (ModalRoute.of(context).settings.name != '/trash') {
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
                    if (ModalRoute.of(context).settings.name != '/about') {
                      goTOAboutMeScreen(context);
                    }

                    //TODO implement this
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
                    if (ModalRoute.of(context).settings.name !=
                        '/suggestions') {
                      goTOBugScreen(context);
                    }
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
                  padding: EdgeInsets.only(bottom: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}