import 'dart:async';
import 'package:flutter/material.dart';
import 'barrier.dart';
import 'bird.dart';
import 'coverscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 2.5;
  double jumpVelocity = 2.0;
  double maxJumpHeight = 0.6;
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  bool gameHasStarted = false;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  int score = 0;
  int bestScore = 0;
  int currentLevel = 0;

  List<LinearGradient> backgroundGradients = [
    LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
    LinearGradient(colors: [Colors.deepPurple, Colors.pinkAccent]),
    LinearGradient(colors: [Colors.orange, Colors.redAccent]),
    LinearGradient(colors: [Colors.teal, Colors.greenAccent]),
  ];

  Timer? gameLoop;

  @override
  void dispose() {
    gameLoop?.cancel();
    super.dispose();
  }

  void startGame() {
    gameHasStarted = true;
    time = 0;
    score = 0;
    currentLevel = 0;
    initialPos = birdY;

    gameLoop = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;

        if (birdY < -maxJumpHeight) {
          birdY = -maxJumpHeight;
          time = 0;
          initialPos = -maxJumpHeight;
        }
      });

      if (birdIsDead()) {
        gameLoop?.cancel();
        gameHasStarted = false;
        _showDialog();
      } else {
        moveMap();
      }

      time += 0.05;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.03;

        if (barrierX[i] <= -1.5) {
          barrierX[i] += 3;
          score++;
          if (score > bestScore) {
            bestScore = score;
          }
          updateLevel();
        }
      });
    }
  }

  void updateLevel() {
    int newLevel = score ~/ 10;
    if (newLevel != currentLevel && newLevel < backgroundGradients.length) {
      setState(() {
        currentLevel = newLevel;
      });
    }
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      barrierX = [2, 2 + 1.5];
      score = 0;
      currentLevel = 0;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Center(
            child: Text(
              'G A M E  O V E R',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Score: $score',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                'Best Score: $bestScore',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    'PLAY AGAIN',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
      velocity = jumpVelocity;
    });
  }

  bool birdIsDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth) {
        if (birdY <= -1 + barrierHeight[i][0] ||
            birdY + birdHeight >= 1 - barrierHeight[i][1]) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: backgroundGradients[currentLevel],
                ),
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(
                        birdY: birdY,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                      ),
                      MyCoverScreen(gameHasStarted: gameHasStarted),
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                        isThisBottomBarrier: false,
                      ),
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        isThisBottomBarrier: true,
                      ),
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        isThisBottomBarrier: false,
                      ),
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        isThisBottomBarrier: true,
                      ),
                      Container(
                        alignment: const Alignment(0, -0.5),
                        child: Text(
                          gameHasStarted ? '' : 'T A P  T O  P L A Y',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 5,
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                )
                              ]),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 10,
                        child: Column(
                          children: [
                            Text(
                              'Score: $score',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5,
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                    )
                                  ]),
                            ),
                            Text(
                              'Best: $bestScore',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5,
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                    )
                                  ]),
                            ),
                            Text(
                              'Level: ${currentLevel + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5,
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.brown, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
