import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double barrierWidth;
  final double barrierHeight;
  final double barrierX;
  final bool isThisBottomBarrier;

// Constructor
  const MyBarrier({
    Key? key,
    required this.barrierWidth,
    required this.barrierHeight,
    required this.barrierX,
    required this.isThisBottomBarrier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(
        (2 * barrierX + barrierWidth) / (2 - barrierWidth),
        isThisBottomBarrier ? 1 : -1,
      ),
      child: Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width * (barrierWidth / 2),
        height:
            MediaQuery.of(context).size.height * (3 / 4 * barrierHeight / 2),
      ),
    );
  }
}
