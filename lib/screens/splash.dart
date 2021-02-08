import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
      child: RotationTransition(
        turns: AlwaysStoppedAnimation(60 / 360),
        child: Image.asset(
          'images/banana.png',
          alignment: Alignment.center,
          scale: 10,
        ),
      ),
    );
  }
}
