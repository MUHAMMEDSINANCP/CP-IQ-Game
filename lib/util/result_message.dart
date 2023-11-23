import 'package:flutter/material.dart';
import '../const.dart';

class ResultMessage extends StatelessWidget {
  final String message;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final String topmessage;

  const ResultMessage({
    Key? key,
    required this.message,
    required this.onTap,
    required this.icon,
    required this.color,
    required this.topmessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color,
      content: SizedBox(
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // the result
            Text(
              topmessage,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(
              height: 5,
              color: Colors.white,
            ),
            Text(
              message,
              style: whiteTextStyle,
            ),
            const SizedBox(
              height: 6,
            ),

            // button to go to next question
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Shadow color
                      spreadRadius: 4, // Spread radius
                      blurRadius: 4, // Blur radius
                      offset: const Offset(0, 2), // Shadow position
                    ),
                  ],
                  color: Colors.deepPurple[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
