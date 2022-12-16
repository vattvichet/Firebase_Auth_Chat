import 'package:flutter/material.dart';

class GetDialog extends StatelessWidget {
  const GetDialog({
    Key key,
    @required this.notificationType,
    @required this.content,
    @required this.backgroundColor,
    @required this.buttonColor,
  }) : super(key: key);

  final String notificationType;
  final String content;
  final Color backgroundColor;
  final Color buttonColor;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text(notificationType),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Container(
            color: buttonColor,
            padding: const EdgeInsets.all(14),
            child: const Text("okay"),
          ),
        ),
      ],
    );
  }
}
