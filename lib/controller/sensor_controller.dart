import 'package:flutter/services.dart';

class SensorController {
  static const gyroChannel = EventChannel('gyro');

  static Stream<Map> get stream =>
      gyroChannel.receiveBroadcastStream().map((event) => Map.from(event));
}