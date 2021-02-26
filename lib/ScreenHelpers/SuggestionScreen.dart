import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:notes/util/DrawerManager.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/PopUp.dart';

_SuggestionsScreenHelperState suggestion ;
class SuggestionsScreenHelper extends StatefulWidget {
  final DrawerManager drawerManager;
  SuggestionsScreenHelper(this.drawerManager);

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
      title: 'Notes',
      imagePath: 'assets/images/img3.jpg',
    );
  }
  void callSetState() {
    setState(() {},);
  }

  @override
  Widget build(BuildContext context) {
    suggestion = this;
    return AnimatedContainer(
      transform: Matrix4Transform()
          .translate(x: widget.drawerManager.xOffSet, y: widget.drawerManager.yOffSet)
          .rotate(widget.drawerManager.angle)
          .matrix4,
      duration: Duration(milliseconds: 250),
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Suggestions',
          imagePath: 'assets/images/img3.jpg',
        ),
        body: DoubleBackToCloseWidget(
          child: Center(
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
      ),
    );
  }
}
