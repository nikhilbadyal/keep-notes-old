import 'package:flutter/material.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';

class AboutMeScreenHelper extends StatefulWidget {
  const AboutMeScreenHelper();

  @override
  _AboutMeScreenHelperState createState() {
    return _AboutMeScreenHelperState();
  }
}

class _AboutMeScreenHelperState extends State<AboutMeScreenHelper>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    //debugPrint('building 4 ');
    return DoubleBackToCloseWidget(
      child: Scaffold(
        appBar: const MyAppBar(
          title: 'About Me',
        ),
        body: DoubleBackToCloseWidget(
          child: SafeArea(
            child: body(context),
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
                  onTap: () {
                    Utilities.launchUrl('https://github.com/ProblematicDude');
                  },
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/img3.jpg'),
                    radius: 50.0,
                  ),
                ),
              ),
              const Divider(
                height: 60.0,
                color: Colors.black,
              ),
              const Text(
                'Name',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Nikhil',
                style: TextStyle(
                  color: headerColor,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Email',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                children: const <Widget>[
                  Icon(
                    Icons.email,
                    color: headerColor,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'nikhildevelops@gmail.com',
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
      ),
    );
  }
}
