import 'dart:async';

import 'package:flutter/material.dart';
import 'package:module_b/controller/audio_player.dart';
import 'package:module_b/utils/info.dart';
import 'package:module_b/utils/utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  double _treeOffset = 0;

  ValueNotifier<int> startCoin = ValueNotifier(10);

  int playTime = 0;
  Timer? timer;

  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    AudioPlayer.playBGM();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addListener(
            () => setState(() {
              _treeOffset -= 3;
            }),
          );
    controller.repeat();
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) => setState(() => playTime++),
    );
  }

  @override
  void dispose() {
    AudioPlayer.endBGM();
    controller.dispose();
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
          controlPlayer(),
          topBar(),
          ?isPlaying ? null : stopGame(),
        ],
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
      top: screenH * 0.35,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Transform.rotate(
            angle: -0.1,
            child: Container(
              width: screenW * 1.5,
              height: screenH * 0.35,
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 30,
            left: screenW * 0.3,
            child: playImage(hue: imageHue, h: 120),
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
                    controller.stop();
                    timer?.cancel();
                  } else {
                    AudioPlayer.restartBGM();
                    controller.repeat();
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
        Image.asset("assets/images/coin.png", height: 25),
        SizedBox(width: 5),
        Text(
          "${startCoin.value}",
          style: TextStyle(
            color: Color(0xfff5ce1c),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget treeImage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final treeW = constraints.maxWidth;
        final offset = (_treeOffset % treeW + treeW) % treeW;
        return Stack(
          children: [
            Positioned(
              bottom: 0,
              left: offset - treeW - 130,
              child: Image.asset(
                "assets/images/trees.png",
                fit: BoxFit.fitWidth,
                width: treeW * 2.2,
              ),
            ),
            Positioned(
              bottom: 0,
              left: offset - 20,
              child: Image.asset(
                "assets/images/trees.png",
                fit: BoxFit.fitWidth,
                width: treeW * 2.2,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget stopGame() {
    return Container(
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
    );
  }
}
