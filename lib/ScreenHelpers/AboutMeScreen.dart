import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/main.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';

_AboutMeScreenHelperState aboutMe;

class AboutMeScreenHelper extends StatefulWidget {
  @override
  _AboutMeScreenHelperState createState() {
    return _AboutMeScreenHelperState();
  }
}

class _AboutMeScreenHelperState extends State<AboutMeScreenHelper> {
  MyAppBar appbar;

  @override
  void initState() {
    super.initState();
    appbar = MyAppBar(
      title: 'Archive',
      imagePath: 'assets/images/img3.jpg',
    );
  }

  void invokeSetState() {
    setState(() {});
  }

  void callSetState() {
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    aboutMe = this;
    return AnimatedContainer(
      transform: Matrix4Transform()
          .translate(
              x: myNotes.drawerManager.xOffSet,
              y: myNotes.drawerManager.yOffSet)
          .rotate(myNotes.drawerManager.angle)
          .matrix4,
      duration: Duration(milliseconds: 250),
      child: DoubleBackToCloseWidget(
        child: Scaffold(
          appBar: MyAppBar(
            title: 'About',
            imagePath: 'assets/images/img3.jpg',
          ),
          body: DoubleBackToCloseWidget(
            child: SafeArea(
              child: body(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/img3.jpg'),
                  radius: 50.0,
                ),
                onTap: (){
                  Utilities.launchUrl("https://github.com/ProblematicDude");
                },
              ),
            ),
            Divider(
              height: 60.0,
              color: Colors.black,
            ),
            Text(
              'Name',
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              'Nikhil',
              style: TextStyle(
                color: headerColor,
                letterSpacing: 2.0,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              'Email',
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: headerColor,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'nahibtaunga@gmail.com',
                  style: TextStyle(
                    color: headerColor,
                    letterSpacing: 2.0,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
