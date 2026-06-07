import 'package:flutter/services.dart';

class AudioPlayer {
  static MethodChannel channel = MethodChannel("audio");

  static void playBGM() => channel.invokeMethod("playBGM");

  static void stopBGM() => channel.invokeMethod("stopBGM");

  static void restartBGM() => channel.invokeMethod("restartBGM");

  static void endBGM() => channel.invokeMethod("endBGM");

  static setSound(double sound) =>
      channel.invokeMethod('setSound', {'sound': sound});

  static void playSoundEffect(String effectName) =>
      channel.invokeMethod('soundEffect', {'effectName': effectName});

  static void coin() => playSoundEffect("coin.wav");

  static void gameOver() => playSoundEffect("game_over.wav");

  static void jump() => playSoundEffect("jump.wav");
}
