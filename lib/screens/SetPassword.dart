//20-12-2020

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/screens/LockScreen.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:notes/widget/Navigations.dart';

class SetPassword extends StatefulWidget {
  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  String enteredPassCode = "";
  bool isFirst;
  String firstPass;
  String title;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  void _onTap(String text) {
    setState(() {
      if (isFirst) {
        if (enteredPassCode.length < 4) {
          enteredPassCode += text;
          if (enteredPassCode.length == 4) {
            _doneEnteringPass(enteredPassCode);
          }
        }
      } else {
        if (enteredPassCode.length < firstPass.length) {
          enteredPassCode += text;
          if (enteredPassCode.length == firstPass.length) {
            _doneEnteringPass(enteredPassCode);
          }
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

  Future<void> _doneEnteringPass(String enteredPassCode) async {
    if (isFirst) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPassword(),
            settings: RouteSettings(
              arguments: DataObj(false, enteredPassCode, "Re Enter Password"),
            ),
          ));
    } else {
      if (enteredPassCode == firstPass) {
        myNotes.lockChecker.passwordSet = true;
        myNotes.lockChecker.password = enteredPassCode;
        await Utilities.addBoolToSF("passwordSet", true);
        await Utilities.addStringToSF('password', enteredPassCode);
        myNotes.lockChecker.updateDetails();
        goTOHiddenScreen(context);
      } else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          Utilities.getExitSnackBar(context, "PassCodes doesn't match"),
        );
        goToSetPasswordScreen(context);
      }
    }
  }

  Widget _titleWidget(String title) {
    return Container(
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  void ValidationCheck() {}

  @override
  Widget build(BuildContext context) {
    final DataObj args = ModalRoute.of(context).settings.arguments;
    isFirst = args.isFirst;
    firstPass = args.firstPass;
    title = args.heading;
    Widget titleWidget = _titleWidget(title);
    return DoubleBackToCloseWidget(
      child: MyLockScreen(
          title: titleWidget,
          onTap: _onTap,
          onDelTap: _onDelTap,
          onFingerTap: null,
          enteredPassCode: enteredPassCode,
          stream: _verificationNotifier.stream),
    );
  }
}

class DataObj {
  final bool isFirst;
  final String firstPass;
  final String heading;

  DataObj(this.isFirst, this.firstPass, this.heading);
}
