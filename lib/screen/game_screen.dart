import 'dart:async';
import 'dart:math' hide log;
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:module_b/controller/audio_player.dart';
import 'package:module_b/controller/sensor_controller.dart';
import 'package:module_b/screen/app_screen.dart';
import 'package:module_b/screen/ranking_screen.dart';
import 'package:module_b/utils/info.dart';
import 'package:module_b/utils/utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final ScrollController treeController = ScrollController();
  final ScrollController objectController = ScrollController();
  double _treeOffset = 0;

  List<String> objectList = List.generate(
    200,
    (index) => Random().nextBool() ? "coin" : "obstacle",
  );

  Set<int> coinHit = {};
  Set<int> obstacleHit = {};

  ValueNotifier<int> startCoin = ValueNotifier(10);

  int playTime = 0;
  Timer? timer;

  bool isPlaying = true;

  bool isJumping = false;
  double playerBottom = 40;

  double angle = 0.1;

  StreamSubscription? sensor;

  bool isBoost = false;
  bool isGameEnd = false;
  bool isGameOver = false;

  void startSensor() {
    sensor = SensorController.stream.listen(
      (event) => setState(() {
        if (!isPlaying) return;
        angle = (angle + event['z'] * 0.01).clamp(0.0, 0.3);
        _treeOffset += angle * 10 * (isBoost ? 4 : 1);
        treeController.jumpTo(_treeOffset);
        objectController.jumpTo(_treeOffset);
        hit();
        AudioPlayer.setSound(angle / 0.3);
      }),
    );
  }

  void stopSensor() {
    sensor?.cancel();
    sensor = null;
  }

  void hit() {
    final screenW = MediaQuery.of(context).size.width;
    final index = ((_treeOffset + screenW * 0.37) / screenW).floor();
    if (index < 1) return;
    if (obstacleHit.contains(index)) return;
    obstacleHit.add(index);
    if (isJumping) return;

    if (objectList[index] == "coin") {
      setState(() => startCoin.value++);
      AudioPlayer.coin();
      coinHit.add(index);
    } else {
      gameOver();
    }
  }

  void gameOver() {
    stopSensor();
    timer?.cancel();
    AudioPlayer.stopBGM();
    AudioPlayer.gameOver();
    setState(() => isGameOver = true);
  }

  @override
  void initState() {
    super.initState();
    AudioPlayer.playBGM();
    startSensor();
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) => setState(() => playTime++),
    );
  }

  @override
  void dispose() {
    AudioPlayer.endBGM();
    treeController.dispose();
    objectController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          bgImage(),
          treeImage(),
          objectImage(),
          controlPlayer(),
          jumpAction(),
          topBar(),
          if (!isPlaying) stopGame(),
          if (isGameOver) gameOverWidget(),
        ],
      ),
    );
  }

  Widget jumpAction() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 0) {
          setState(() {
            isGameEnd = true;
          });
        }
      },
      onHorizontalDragEnd: (details) {
        if (isGameEnd) {
          gameEnd();
          setState(() {
            AudioPlayer.stopBGM();
            stopSensor();
            timer?.cancel();
            isPlaying = false;
            isGameEnd = false;
          });
        }
      },
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! > 0) {
          setState(() => isBoost = true);
        }
      },
      onVerticalDragEnd: (details) => setState(() => isBoost = false),
      onTap: () {
        if (isJumping || !isPlaying) return;
        isJumping = true;
        AudioPlayer.jump();
        setState(() => playerBottom = 200);

        Future.delayed(
          Duration(milliseconds: 600),
          () {
            setState(() => playerBottom = 40);
            Future.delayed(
              Duration(milliseconds: 600),
              () => isJumping = false,
            );
          },
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }

  void gameEnd() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to quit the game?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppScreen(),
              ),
            ),
            child: Text("YES"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isPlaying = true;
                AudioPlayer.restartBGM();
                startSensor();
                timer = Timer.periodic(
                  Duration(seconds: 1),
                  (timer) => setState(() => playTime++),
                );
              });
              Navigator.pop(context);
            },
            child: Text("NO"),
          ),
        ],
      ),
    );
  }

  Widget gameOverWidget() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        alignment: Alignment.center,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Game Over",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 15),
              Text(
                "Player name: $playerName",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  currentCoin(),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "time: ${playTime}s",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isGameOver = false;
                        isPlaying = true;
                        playTime = 0;
                        startCoin.value = 10;
                        _treeOffset = 0;
                        coinHit.clear();
                        obstacleHit.clear();
                        objectList = List.generate(
                          200,
                          (index) => Random().nextBool() ? "coin" : "obstacle",
                        );
                        objectController.jumpTo(0);
                        treeController.jumpTo(0);
                        AudioPlayer.playBGM();
                        startSensor();
                        timer = Timer.periodic(
                          Duration(seconds: 1),
                          (timer) => setState(() => playTime++),
                        );
                      });
                    },
                    child: Text(
                      "Restart",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RankingScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Go To Rankings",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget objectImage() {
    final screenW = MediaQuery.of(context).size.width;

    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Transform.rotate(
        angle: angle,
        child: SizedBox(
          height: 50,
          child: ListView.builder(
            controller: objectController,
            physics: NeverScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: objectList.length,
            itemBuilder: (context, index) {
              if (index < 1) return SizedBox(width: screenW);
              if (coinHit.contains(index)) return SizedBox(width: screenW);

              bool isCoin = objectList[index] == "coin";

              return SizedBox(
                width: screenW,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    "assets/images/${objectList[index]}.png",
                    width: isCoin ? 30 : 50,
                    height: isCoin ? 30 : 50,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget controlPlayer() {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: screenH * 0.25,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -250,
            left: -60,
            child: Transform.rotate(
              angle: angle,
              child: Container(
                width: screenW * 1.7,
                height: screenH * 0.35,
                color: Colors.white,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOut,
            bottom: playerBottom,
            left: screenW * 0.3,
            child: Transform.rotate(
              angle: angle,
              child: playImage(hue: imageHue, h: 100),
            ),
          ),
        ],
      ),
    );
  }

  Widget topBar() {
    return Align(
      alignment: .topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  isPlaying = !isPlaying;
                  if (!isPlaying) {
                    AudioPlayer.stopBGM();
                    stopSensor();
                    timer?.cancel();
                  } else {
                    AudioPlayer.restartBGM();
                    startSensor();
                    timer = Timer.periodic(
                      Duration(seconds: 1),
                      (timer) => setState(() => playTime++),
                    );
                  }
                });
              },
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.black,
                size: 40,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 15),
                Text(
                  playerName!,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
                ),
                SizedBox(height: 15),
                currentCoin(),
                SizedBox(height: 10),
                Text(
                  "$playTime S  ",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget currentCoin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,

      children: [
        Image.asset("assets/images/coin.png", height: 22),
        SizedBox(width: 5),
        Text(
          "${startCoin.value}",
          style: TextStyle(
            color: Color(0xfff5ce1c),
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget treeImage() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 400,
        child: ListView.builder(
          controller: treeController,
          physics: NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          itemCount: 100,
          itemBuilder: (context, index) => Transform.scale(
            scale: 1.2,
            child: Image.asset("assets/images/trees.png"),
          ),
        ),
      ),
    );
  }

  Widget stopGame() {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.3),
          child: Text(
            "Game suspended...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        Positioned(
          top: 39,
          left: 16,
          child: IconButton(
            onPressed: () {
              setState(() {
                isPlaying = !isPlaying;
                if (!isPlaying) {
                  AudioPlayer.stopBGM();
                  stopSensor();
                  timer?.cancel();
                } else {
                  AudioPlayer.restartBGM();
                  startSensor();
                  timer = Timer.periodic(
                    Duration(seconds: 1),
                    (timer) => setState(() => playTime++),
                  );
                }
              });
            },
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
