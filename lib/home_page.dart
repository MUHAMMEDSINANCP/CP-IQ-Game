import 'dart:math';
import 'package:confetti/confetti.dart';
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
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    generateNewQuestion(); // Generate initial question
  }

  void generateNewQuestion() {
    setState(() {
      numberA = Random().nextInt(100);
      numberB = Random().nextInt(1000);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

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
    'NEXT',
    '',
    '0',
    '',
    '=',
  ];

  int? numberA;
  int? numberB;

  String userAnswer = '';

  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        if (userAnswer.isEmpty) {
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
          checkResult();
        }
      } else if (button == 'C') {
        userAnswer = '';
      } else if (button == 'DEL') {
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (button == 'NEXT') {
        generateNewQuestion();
        userAnswer = ''; // Reset user's answer when displaying a new question
      } else if (userAnswer.length < 9) {
        userAnswer += button;
      }
    });
  }

  void checkResult() {
    if (numberA != null &&
        numberB != null &&
        ((numberA! + numberB!) == int.parse(userAnswer) ||
            (numberA! * numberB!) == int.parse(userAnswer))) {
      _confettiController.play();

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
        },
      );
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
        },
      );
    }
  }

  void goToNextQuestion() {
    Navigator.of(context).pop();

    setState(() {
      userAnswer = '';
      generateNewQuestion();
    });
  }

  void goBackToQuestion() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
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
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: 'CP',
                    style: TextStyle(
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' IQ Game'),
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
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 200,
                      ),
                      Text(
                        '${numberA ?? ''} + ${numberB ?? ''} = ',
                        style: whiteTextStyle,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
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
                SizedBox(
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: numberPad.length,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemBuilder: (context, index) {
                        return MyButton(
                          textStyle: numberPad[index] == 'NEXT'
                              ? const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )
                              : whiteTextStyle,
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
        ),
        ConfettiWidget(
          blastDirectionality: BlastDirectionality.explosive,
          confettiController: _confettiController,
          blastDirection: pi / 2,
          emissionFrequency: 0.50,
          numberOfParticles: 4,
          gravity: 0.76,
        ),
      ],
    );
  }
}
