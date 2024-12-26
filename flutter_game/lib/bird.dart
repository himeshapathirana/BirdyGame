import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final double birdY;
  final double birdWidth;
  final double birdHeight;

// Constructor
  const MyBird({
    Key? key,
    required this.birdY,
    required this.birdWidth,
    required this.birdHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: Image.asset(
        'lib/images/birds-3.png',
        width: MediaQuery.of(context).size.width * (birdWidth / 2),
        height: MediaQuery.of(context).size.height * (3 / 4 * birdHeight / 2),
        fit: BoxFit.fill,
      ),
    );
  }
}
