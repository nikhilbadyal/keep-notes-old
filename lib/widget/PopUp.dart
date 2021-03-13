//24-12-2020
/*

import 'package:flutter/material.dart';
import 'package:notes/util/Utilites.dart';

class CustomDialog extends StatefulWidget {
  final String title;

  final String descriptions;

  final String firstOption;

  final String secondOption;

  final Function onFirstPressed;
  final Function onSecondPressed;

  const CustomDialog(
      {Key key,
      @required this.title,
      @required this.descriptions,
      @required this.firstOption,
      @required this.secondOption,
      @required this.onFirstPressed,
      @required this.onSecondPressed}) //TODO add assert
      : assert(firstOption != '' || onFirstPressed == null),
        super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  Image image;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Utilities.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: Utilities.padding,
              top: Utilities.avatarRadius + Utilities.padding,
              right: Utilities.padding,
              bottom: Utilities.padding),
          margin: EdgeInsets.only(top: Utilities.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Utilities.dialogColor,
            borderRadius: BorderRadius.circular(Utilities.padding),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title != '')
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: _alignment(),
                    child: TextButton(
                      onPressed: widget.onFirstPressed == null
                          ? () {
                              Navigator.of(context).pop();
                            }
                          : widget.onFirstPressed,
                      child: Text(widget.firstOption),
                    ),
                  ),
                  if (widget.secondOption != '')
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: widget.onSecondPressed,
                        child: Text(widget.secondOption),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          left: Utilities.padding,
          right: Utilities.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Utilities.avatarRadius,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(Utilities.avatarRadius),
              ),
              child: Image.asset('assets/images/error1.png'),
            ),
          ),
        ),
      ],
    );
  }

  Alignment _alignment() {
    if (widget.secondOption == '') {
      return Alignment.center;
    }
    return Alignment.bottomLeft;
  }
}
*/
