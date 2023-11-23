import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  final String child;
  final TextStyle? textStyle;
  final VoidCallback onTap;
  var buttonColor = Colors.deepPurple[400];

  MyButton({
    Key? key,
    required this.child,
    required this.onTap,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (child == 'C') {
      buttonColor = Colors.red;
    } else if (child == 'DEL') {
      buttonColor = Colors.orange;
    } else if (child == '=') {
      buttonColor = Colors.green;
    } else if (child == 'NEXT') {
      buttonColor = Colors.brown;
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              child,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
