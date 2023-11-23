import 'dart:math';

import 'package:cp_iq_game/const.dart';
import 'package:cp_iq_game/util/my_button.dart';
import 'package:cp_iq_game/util/result_message.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // number pad list
  List<String> numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    'DEL',
    '1',
    '2',
    '3',
    '=',
    '0',
  ];

  // number A, number B
  int numberA = 1;
  int numberB = 1;

  // user answer
  String userAnswer = '';

  // user tapped a button
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        if (userAnswer.isEmpty) {
          // Show a snackbar if the answer field is empty
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              animation: AlwaysStoppedAnimation(2),
              closeIconColor: Colors.white,
              content: Text(
                'Please enter an answer.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else {
          // Calculate if the user is correct or incorrect
          checkResult();
        }
      } else if (button == 'C') {
        // Clear the input
        userAnswer = '';
      } else if (button == 'DEL') {
        // Delete the last number
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (userAnswer.length < 9) {
        // Maximum of 3 numbers can be inputted
        userAnswer += button;
      }
    });
  }

  // check if user is correct or not
  void checkResult() {
    if (numberA + numberB == int.parse(userAnswer)) {
      showDialog(
          context: context,
          builder: (context) {
            return ResultMessage(
              topmessage: 'Yay! Well-Done.',
              color: Colors.green,
              message: 'Correct Answer',
              onTap: goToNextQuestion,
              icon: Icons.arrow_forward,
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return ResultMessage(
              topmessage: 'Oops! Try again.',
              color: Colors.redAccent,
              message: 'Wrong Answer',
              onTap: goBackToQuestion,
              icon: Icons.rotate_left,
            );
          });
    }
  }

  // create random numbers
  var randomNumber = Random();

  // GO TO NEXT QUESTION
  void goToNextQuestion() {
    // dismiss alert dialog
    Navigator.of(context).pop();

    // reset values
    setState(() {
      userAnswer = '';
    });

    // create a new question
    numberA = randomNumber.nextInt(10);
    numberB = randomNumber.nextInt(10);
  }

  // GO BACK TO QUESTION
  void goBackToQuestion() {
    // dismiss alert dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(
              Icons.calculate_outlined,
              size: 39,
            ),
          ),
        ],
        leading: const Icon(
          Icons.calculate_rounded,
          size: 38,
        ),
        centerTitle: true,
        toolbarHeight: 64,
        backgroundColor: Colors.deepPurple,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 25, // Adjust the font size as needed
              fontWeight: FontWeight.normal, // Set the default font weight
              color: Colors.white, // Set the default text color
            ),
            children: [
              TextSpan(
                text: 'CP', // Your bold text here
                style: TextStyle(
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  // You can add any other styles specific to the bold text here
                ),
              ),
              TextSpan(text: ' IQ Game'), // Rest of the text
            ],
          ),
        ),
      ),
      backgroundColor: Colors.deepPurple[300],
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // level progress, player needs 5 correct answers in a row to proceed to next level
            // Container(
            //   height: 160,
            //   color: Colors.deepPurple,
            // ),

            // question
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // question
                  const SizedBox(
                    height: 200,
                  ),
                  Text(
                    '$numberA + $numberB = ',
                    style: whiteTextStyle,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  // answer box
                  Container(
                    padding: const EdgeInsets.all(10),
                    constraints: const BoxConstraints(
                      minHeight: 51,
                      maxHeight: 51,
                      minWidth: 65,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        userAnswer,
                        style: whiteTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // number pad
            SizedBox(
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: numberPad.length,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) {
                    return MyButton(
                      child: numberPad[index],
                      onTap: () => buttonTapped(numberPad[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
