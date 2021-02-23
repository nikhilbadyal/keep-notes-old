//20-12-2020

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/screens/LockScreen.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/PopUp.dart';

class SetPassword extends StatefulWidget {
  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  var numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
  var inputText = '';
  var actives = [false, false, false, false, false];
  var clears = [false, false, false, false, false];
  var values = [1, 2, 3, 2, 1];
  var currentIndex = 0;
  var message = '';
  LocalAuthentication localAuthentication = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter New password',
                  style: TextStyle(
                    // color: Colors.white,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  height: 100,
                  // color: Colors.blue,
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
                /* Text(
                  message,
                  style: TextStyle(
                    color: Colors.green ,
                  ),
                ),*/
              ],
            ),
          ),
          Expanded(
            // flex: 1,
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
                            // color: Colors.blue,
                            minWidth: 55.0,
                            height: 55.0,
                            child: index == 11
                                ? Icon(
                                    Icons.backspace_outlined,
                                    // color: Colors.white,
                                    color: Colors.blue,
                                  )
                                : Text(
                                    '${numbers[index == 10 ? index - 1 : index]}',
                                    style: TextStyle(
                                      // color: Colors.white,
                                      color: Colors.blue,
                                      fontSize: 26.0,
                                    ),
                                  ),
                            onPressed: () async {
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
                                  message = 'Pass is ' + inputText;
                                  Utilities.showMyToast(message, 3,
                                      ToastGravity.CENTER, Colors.green);
                                  LockChecker.passwordSet = true;
                                  LockChecker.password = inputText;
                                  await Utilities.addBoolToSF(
                                      "passwordSet", true);
                                  await Utilities.addStringToSF(
                                      'password', inputText);
                                  LockChecker.updateDetails();
                                  if (await Utilities.isBioAvailable()) {
                                    promptUser(context);
                                  }
                                  inputText = '';
                                  currentIndex = 0;
                                  return;
                                }
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
          /*  SizedBox(
            height: 50.0,
          ),*/
        ],
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
              LockChecker.bioEnabled = false;
              Utilities.addBoolToSF('bio', false);
              await LockChecker.updateDetails();
              await Navigator.of(context).pushNamedAndRemoveUntil(
                  '/lock', (Route<dynamic> route) => false);
            },
          ),
        ) ??
        false; // In case the user dismisses the dialog by clicking away from it
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
        // color: Colors.redAccent,
        child: Stack(
          children: [
            Container(),
            AnimatedContainer(
              duration: Duration(milliseconds: 800),
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    widget.active ? Colors.black : Colors.blue, // Colors.white,
                // color: widget.active ? Colors.grey :Colors.blue,// Colors.white,
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
                    color: widget.active
                        ? Colors.grey
                        : Colors.blue, //Colors.white,
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
