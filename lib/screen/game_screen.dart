import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..addListener(() => setState(() => _treeOffset = (_treeOffset - 3)));
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          bgImage(),
          treeImage(),
          //플레이어 + 경사면
          //상단바
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ],
      ),
    );
  }

  Widget treeImage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final treeW = constraints.maxWidth * 2.2;
        final offset = ((_treeOffset % treeW) + treeW) % treeW-10;
        return Stack(
          children: [
            Positioned(
              bottom: 0,
              left: offset-treeW,
              child: Image.asset(
                "assets/images/trees.png",
                width: treeW,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              bottom: 0,
              left: offset-130,
              child: Image.asset(
                "assets/images/trees.png",
                width: treeW,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        );
      },
    );
  }
}
