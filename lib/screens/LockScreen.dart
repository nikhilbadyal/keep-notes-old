import 'package:flutter/material.dart';
import 'package:notes/database/NotesHelper.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/Navigations.dart';
import 'package:notes/widget/PopUp.dart';
import 'package:provider/provider.dart';

import '../main.dart';


class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final password;

  var numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
  var inputText = '';
  var actives = [false, false, false, false, false];
  var clears = [false, false, false, false, false];
  var values = [1, 2, 3, 2, 1];
  var currentIndex = 0;
  var message = '';
  String condition;

  _LockScreenState({this.password});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 40.0,
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ),
            Expanded(
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Enter password',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < actives.length; ++i)
                          AnimatedBox(
                            clear: clears[i],
                            active: actives[i],
                            value: values[i],
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (await Utilities.isBioAvailable()) {
                        errorPopUp(context,
                            "Password can't be recovered. Delete all Hidden Notes?");
                      } else {}
                    },
                    child: Text(
                      message,
                      style: TextStyle(
                        color: message == 'success'
                            ? Colors.green
                            : Colors.redAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  myNotes.lockChecker.bioEnabled
                      ? GestureDetector(
                          onTap: () {
                            promptFinger(context);
                          },
                          child: Text(
                            'Use FinerPrint',
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      : myNotes.lockChecker.bioAvailable
                          ? GestureDetector(
                              onTap: () {
                                promptUser(context);
                              },
                              child: Text(
                                'SetUp FinerPrint',
                                style: TextStyle(color: Colors.green),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {},
                              child: Text(
                                '',
                              ),
                            )
                ],
              ),
            ),
            Expanded(
              flex: 15,
              child: GridView.builder(
                padding: EdgeInsets.all(0.0),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8 / 0.6,
                ),
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.all(4.0),
                  width: 50.0,
                  height: 50.0,
                  // height: MediaQuery.of(context).size.height/8,
                  child: Center(
                    child: index == 9
                        ? SizedBox()
                        : Center(
                            child: MaterialButton(
                              minWidth: 55.0,
                              height: 55.0,
                              child: index == 11
                                  ? Icon(
                                      Icons.backspace_outlined,
                                      color: Colors.blue,
                                    )
                                  : Text(
                                      '${numbers[index == 10 ? index - 1 : index]}',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 26.0,
                                      ),
                                    ),
                              onPressed: () {
                                if (index == 11) {
                                  currentIndex--;
                                  if (inputText.isEmpty) {
                                    currentIndex = 0;
                                  } else {
                                    inputText = inputText.substring(
                                        0, inputText.length - 1);
                                    clears = clears.map((e) => false).toList();
                                    setState(() {
                                      clears[currentIndex] = true;
                                      actives[currentIndex] = false;
                                    });
                                    return;
                                  }
                                } else {
                                  inputText +=
                                      numbers[index == 10 ? index - 1 : index]
                                          .toString();
                                  if (inputText.length == 5) {
                                    setState(() {
                                      clears = clears.map((e) => true).toList();
                                      actives =
                                          actives.map((e) => false).toList();
                                    });
                                    if (inputText == myNotes.lockChecker.password) {
                                      message = 'success';
                                      goTOHiddenScreen(context);
                                    } else {
                                      message = 'Forgot Password ?';
                                      setState(() {});
                                    }
                                    inputText = '';
                                    currentIndex = 0;
                                    return;
                                  }
                                  message = '';
                                  clears = clears.map((e) => false).toList();
                                  setState(() {
                                    actives[currentIndex] = true;
                                    currentIndex++;
                                  });
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60.0)),
                            ),
                          ),
                  ),
                ),
                itemCount: 12,
              ),
            ),
  SizedBox(
              height: 50.0,
            ),

          ],
        ),
      ),
    );
  }

  Future<void> errorPopUp(BuildContext context, String data) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => CustomDialog(
        title: '',
        descriptions: data,
        firstOption: 'Proceed',
        secondOption: 'Cancel',
        onFirstPressed: () async {
          await Provider.of<NotesHelper>(this.context, listen: false)
              .deleteAllHiddenNotes();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        },
        onSecondPressed: () {
          return Navigator.of(context).pop(false);
        },
      ),
    );
  }

  Future<bool> promptUser(BuildContext contexto) async {
    return await showDialog<bool>(
          context: contexto,
          builder: (context) => CustomDialog(
            title: '',
            descriptions: 'Want to set FingerPrint?',
            firstOption: 'Yes',
            secondOption: 'Cancel',
            onFirstPressed: () async {
              await Utilities.getListOfBiometricTypes();
              await Utilities.authenticateUser(context);
              return;
            },
            onSecondPressed: () async {
              myNotes.lockChecker.bioEnabled = false;
              Utilities.addBoolToSF('bio', false);
              await myNotes.lockChecker.updateDetails();
              Navigator.of(context).pop(true);
            },
          ),
        ) ??
        false; // In case the user dismisses the dialog by clicking away from it
  }

  Future<bool> promptFinger(BuildContext contexto) async {
    return await showDialog<bool>(
          context: contexto,
          builder: (context) => CustomDialog(
            title: '',
            descriptions: 'Want to use FingerPrint?',
            firstOption: 'Yes',
            secondOption: 'Cancel',
            onFirstPressed: () async {
              if (myNotes.lockChecker.bioEnabled) {
                await Utilities.getListOfBiometricTypes();
                await Utilities.authenticateUser(context);
              } else {
                return await showDialog<bool>(
                  context: contexto,
                  builder: (context) => CustomDialog(
                      title: '',
                      descriptions: 'Fingerprint not setup.',
                      firstOption: 'Ok',
                      secondOption: '',
                      onFirstPressed: () async {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/lock', (Route<dynamic> route) => false);
                      },
                      onSecondPressed: () {}),
                );
              }
            },
            onSecondPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
        ) ??
        false; // In case the user dismisses the dialog by clicking away from it
  }

  Future<bool> _onBackPress() async {
    Navigator.of(this.context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    return true;
  }
}

class AnimatedBox extends StatefulWidget {
  final clear;
  final active;
  final value;

  const AnimatedBox(
      {Key key, this.clear = false, this.active = false, this.value})
      : super(key: key);

  @override
  _AnimatedBoxState createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clear) {
      animationController.forward(from: 0);
    }
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => Container(
        margin: EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(),
            AnimatedContainer(
              duration: Duration(milliseconds: 800),
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.active ? Colors.yellow : Colors.blue,
              ),
            ),
            Align(
              alignment:
                  Alignment(0, animationController.value / widget.value - 1),
              child: Opacity(
                opacity: 1 - animationController.value,
                child: Container(
                  height: 10.0,
                  width: 10.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.active ? Colors.red : Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
