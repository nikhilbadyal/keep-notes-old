import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/Navigations.dart';

import '../main.dart';

typedef KeyboardTapCallback = void Function(String text);
typedef DeleteTapCallback = void Function();
typedef FingerTapCallback = void Function();
typedef DoneCallBack = void Function(String text);

final String pass = "1234";

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String enteredPassCode = "";
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isValid = false;

  void _onTap(String text) {
    setState(() {
      if (enteredPassCode.length < pass.length) {
        enteredPassCode += text;
        if (enteredPassCode.length == pass.length) {
          _doneEnteringPass(enteredPassCode);
        }
      }
    });
  }

  void _onDelTap() {
    if (enteredPassCode.length > 0) {
      setState(() {
        enteredPassCode =
            enteredPassCode.substring(0, enteredPassCode.length - 1);
      });
    }
  }

  void _onFingerTap() {
    if (myNotes.lockChecker.bioEnabled) {
      Utilities.authenticateUser(context);
    } else {
      showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          // TODO user must enter password once after setting up fp
          title: Text('Set Fingerprint first'),
          actions: [
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                Navigator.of(context).pop(true);
                await Utilities.authenticateUser(context);
              },
            ),
            TextButton(
              child: Text('Cancel', style: TextStyle(fontSize: 20)),
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      );
    }
  }

  Widget title = Container(
      child: Text(
    'Enter Password',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ));

  void callSetState(String data) {
    setState(() {
      enteredPassCode = data;
    });
  }

  void _doneEnteringPass(String enteredPassCode) {
    if (enteredPassCode == myNotes.lockChecker.password) {
      goTOHiddenScreen(context);
    } else {
      _verificationNotifier.add(false);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        Utilities.getExitSnackBar(context, "Wrong Passcode"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyLockScreen(
      title: title,
      onTap: _onTap,
      onDelTap: _onDelTap,
      onFingerTap: _onFingerTap,
      enteredPassCode: enteredPassCode,
      stream: _verificationNotifier.stream,
      doneCallBack: callSetState,
    );
  }
}

class MyLockScreen extends StatefulWidget {
  final Widget title;
  final KeyboardTapCallback onTap;
  final DeleteTapCallback onDelTap;
  final FingerTapCallback onFingerTap;
  final String enteredPassCode;
  final Stream<bool> stream;
  final DoneCallBack doneCallBack;

  const MyLockScreen({
    Key key,
    this.title,
    this.onTap,
    this.onDelTap,
    this.onFingerTap,
    this.enteredPassCode,
    this.stream,
    this.doneCallBack,
  }) : super(key: key);

  @override
  _MyLockScreenState createState() => _MyLockScreenState();
}

class _MyLockScreenState extends State<MyLockScreen>
    with SingleTickerProviderStateMixin {
  StreamSubscription<bool> streamSubscription;
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    streamSubscription =
        widget.stream.listen((isValid) => _showValidation(isValid));
    controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: controller, curve: ShakeCurve());
    animation = Tween(begin: 0.0, end: 10.0).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            widget.doneCallBack("");
            controller.value = 0;
          });
        }
      })
      ..addListener(() {
        setState(() {
          // the animation object’s value is the changed state
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseWidget(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: _buildDeleteButton(context),
                      ),
                      widget.title,
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildCircles(widget.enteredPassCode),
                        ),
                      ),
                      _buildKeyBoard(widget.onTap, widget.onDelTap,
                          widget.onFingerTap, widget.enteredPassCode),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showValidation(bool isValid) {
    if (!isValid) {
      controller.forward();
    }
  }
}

List<Widget> _buildCircles(String enteredPassCode) {
  var list = <Widget>[];
  for (int i = 0; i < 4; ++i) {
    list.add(Container(
      margin: EdgeInsets.all(8),
      child: Circle(
        isFilled: i < enteredPassCode.length,
      ),
    ));
  }
  return list;
}

Widget _buildKeyBoard(KeyboardTapCallback _onTap, DeleteTapCallback onDelTap,
    FingerTapCallback onFingerTap, String enteredPassCode) {
  return Container(
      child: Keyboard(
    onKeyboardTap: _onTap,
    onDelTap: onDelTap,
    onFingerTap: onFingerTap,
  ));
}

Widget _buildDeleteButton(BuildContext context) {
  return Row(
    children: [
      IconButton(
        icon: Icon(
          Icons.cancel,
          color: Colors.blue,
          size: 25,
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        },
      ),
    ],
    mainAxisAlignment: MainAxisAlignment.end,
  );
}

class Keyboard extends StatelessWidget {
  final KeyboardTapCallback onKeyboardTap;
  final DeleteTapCallback onDelTap;
  final FingerTapCallback onFingerTap;
  final List<String> keyBoardItem = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '-1',
    '0',
    '-1'
  ];

  Keyboard({Key key, this.onKeyboardTap, this.onDelTap, this.onFingerTap})
      : super(key: key);

  Widget _buildDigit(String text) {
    return Container(
      margin: EdgeInsets.all(2),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onKeyboardTap(text);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    text,
                    semanticsLabel: text,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExtra(Widget widget, DeleteTapCallback onDelTap) {
    return Container(
      margin: EdgeInsets.all(2),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onDelTap();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: widget,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomAlign(
        children: List.generate(12, (index) {
          return index == 9 || index == 11
              ? index == 9
                  ? onFingerTap == null
                      ? Container()
                      : _buildExtra(
                          Icon(Icons.fingerprint_outlined), onFingerTap)
                  : _buildExtra(Icon(Icons.backspace_outlined), onDelTap)
              : _buildDigit(keyBoardItem[index]);
        }),
      ),
    );
  }
}

class CustomAlign extends StatelessWidget {
  final List<Widget> children;

  const CustomAlign({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(25),
      childAspectRatio: 1,
      children: children
          .map((e) => Container(
                width: 5,
                height: 5,
                child: e,
              ))
          .toList(),
    );
  }
}

class Circle extends StatefulWidget {
  final isFilled;

  const Circle({Key key, this.isFilled}) : super(key: key);

  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<Circle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          color: widget.isFilled ? Colors.blueAccent : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blueAccent, width: 2)),
    );
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    //t from 0.0 to 1.0
    return sin(t * 2.5 * pi).abs();
  }
}
