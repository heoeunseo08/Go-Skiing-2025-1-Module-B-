import 'package:flutter/material.dart';
import 'package:module_b/utils/info.dart';
import 'package:module_b/utils/utils.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late double hue;

  @override
  void initState() {
    super.initState();
    hue = imageHue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(width: MediaQuery.of(context).size.width),
          SizedBox(height: 50),
          playImage(hue: hue),
          SizedBox(height: 50),
          selectManColor(),
          SizedBox(height: 50),
          button(
            text: "Done",
            onTap: () {
              imageHue = hue;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget selectManColor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Slider(
        thumbColor: Colors.white,
        activeColor: Color(0xff2d9ffd),
        value: hue,
        min: 0,
        max: 1,
        onChanged: (value) => setState(() => hue = value),
      ),
    );
  }
}
