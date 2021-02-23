import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/AnimatedDrawerHelper/SecondLayer.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/PopUp.dart';

class SuggestionsScreenHelper extends StatefulWidget {
  @override
  _SuggestionsScreenHelperState createState() =>
      _SuggestionsScreenHelperState();
}

class _SuggestionsScreenHelperState extends State<SuggestionsScreenHelper> {
  MyAppBar appbar;
  Widget currentPage;

  @override
  void initState() {
    super.initState();
    appbar = MyAppBar(
      callback: callback,
      title: 'Notes',
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
          title: 'Suggestions',
          callback: callback,
          imagePath: 'assets/images/img3.jpg',
        ),
        body: Center(
          child: CustomDialog(
            title: "Ops",
            descriptions: "Screen not implemented. Come back Soon",
            firstOption: "Ok",
            secondOption: '',
            onSecondPressed: null,
            onFirstPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            },
          ),
        ),
      ),
    );
  }
}
