import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMeScreenHelper extends StatefulWidget {
  @override
  _AboutMeScreenHelperState createState() => _AboutMeScreenHelperState();
}

class _AboutMeScreenHelperState extends State<AboutMeScreenHelper> {
  void _launchUrl() async {
    const url = 'https://github.com/ProblematicDude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  MyAppBar appbar;

  Widget currentPage;

  @override
  void initState() {
    super.initState();
    appbar = MyAppBar(
      callback: callback,
      title: 'Archive',
      imagePath: 'assets/images/img3.jpg',
    );
  }

  void callback(bool isOpen) {
    if (isOpen == true) {
      setState(() {
        xOffSet = 0;
        yOffSet = 0;
        angle = 0;
        isOpen = false;
      });

      secondLayer.setState(() {
        secondLayer.xOffSet = 0;
        secondLayer.yOffSet = 0;
        secondLayer.angle = 0;
      });
    } else {
      setState(() {
        xOffSet = 150;
        yOffSet = 80;
        angle = -0.2;
        isOpen = true;
      });

      secondLayer.setState(
        () {
          secondLayer.xOffSet = 122;
          secondLayer.yOffSet = 110;
          secondLayer.angle = -0.275;
        },
      );
    }
  }

  double xOffSet = 0;
  double yOffSet = 0;
  double angle = 0;

  bool isOpen = false;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4Transform()
          .translate(x: xOffSet, y: yOffSet)
          .rotate(angle)
          .matrix4,
      duration: Duration(milliseconds: 250),
      child: Scaffold(
        appBar: MyAppBar(
          callback: callback,
          title: 'About',
          imagePath: 'assets/images/img3.jpg',
        ),
        body: SafeArea(
          child: body(context),
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
                onTap: _launchUrl,
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
