import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedWelcomeText extends StatelessWidget {
  final String firstLineText;
  final String secondLineText;
  final TextStyle? firstLineStyle;
  final TextStyle? secondLineStyle;

  const AnimatedWelcomeText({
    Key? key,
    required this.firstLineText,
    required this.secondLineText,
    this.firstLineStyle,
    this.secondLineStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        ScaleAnimatedText(
          firstLineText,
          textStyle: firstLineStyle ??
              TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
          textAlign: TextAlign.center,
          duration: Duration(milliseconds: 1000),
        ),
        FadeAnimatedText(
          secondLineText,
          textStyle: secondLineStyle ??
              TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
          textAlign: TextAlign.center,
          duration: Duration(milliseconds: 500),
        ),
      ],
    );
  }
}
