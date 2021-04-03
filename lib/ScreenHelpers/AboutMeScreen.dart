import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/util/DrawerManager.dart';
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

  const AboutMeScreenHelper();
}

class _AboutMeScreenHelperState extends State<AboutMeScreenHelper>
    with TickerProviderStateMixin {
  AnimationController xController;
  AnimationController yController;
  AnimationController angleController;

  @override
  void initState() {
    xController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 150,
    );
    yController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 80,
    );
    angleController = AnimationController(
      duration: Duration(milliseconds: DrawerManager.animationTime),
      vsync: this,
      lowerBound: 0,
      upperBound: 0.2,
    );
    super.initState();
  }

  animate() {
    if (xController.isCompleted) {
      xController.reverse();
      yController.reverse();
      angleController.reverse();
    } else {
      xController.forward(from: 0);
      yController.forward(from: 0);
      angleController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    angleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('building 4 ');
    aboutMe = this;
    return AnimatedBuilder(
      animation: xController,
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4Transform()
              .translate(x: xController.value, y: yController.value)
              .rotate(-angleController.value)
              .matrix4,
          child: child,
        );
      },
      child: DoubleBackToCloseWidget(
        child: Scaffold(
          appBar: MyAppBar(
            title: "About Me",
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
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/img3.jpg'),
                    radius: 50.0,
                  ),
                  onTap: () {
                    Utilities.launchUrl("https://github.com/ProblematicDude");
                  },
                ),
              ),
              Divider(
                height: 60.0,
                color: Colors.black,
              ),
              const Text(
                'Name',
                style: const TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 30.0),
              const Text(
                'Nikhil',
                style: const TextStyle(
                  color: headerColor,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.0),
              const Text(
                'Email',
                style: const TextStyle(
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
                  const Text(
                    'nikhildevelops@gmail.com',
                    style: const TextStyle(
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
      ),
    );
  }
}
