/*
import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/util/Utilites.dart';

Widget _buildKeyboard(){
  return Expanded(
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
              ? GestureDetector(
                  child: Icon(Icons.fingerprint_outlined),
                  onTap: () async {
                    if (myNotes.lockChecker.bioEnabled) {
                      await Utilities.getListOfBiometricTypes();
                      await Utilities.authenticateUser(context);
                    } else {
                      return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          // TODO user must enter password once after setting up fp
                          title: Text('Set Fingerprint first'),
                          actions: [
                            TextButton(
                              child: Text('Ok'),
                              onPressed: () async {
                                await Utilities.getListOfBiometricTypes();
                                await Utilities.authenticateUser(context);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
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
                          inputText =
                              inputText.substring(0, inputText.length - 1);
                          clears = clears.map((e) => false).toList();
                          setState(() {
                            clears[currentIndex] = true;
                            actives[currentIndex] = false;
                          });
                          return;
                        }
                      } else {
                        inputText +=
                            numbers[index == 10 ? index - 1 : index].toString();
                        if (inputText.length == 5) {
                          setState(() {
                            clears = clears.map((e) => true).toList();
                            actives = actives.map((e) => false).toList();
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
  );
}
*/
