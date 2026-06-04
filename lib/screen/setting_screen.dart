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
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: MediaQuery.of(context).size.width),
          playerImage(hue: hue),
          SizedBox(height: 50),
          manColor(),
          SizedBox(height: 50),
          button(
            text: "Done",
            onTap: () {
              imageHue = hue;
              showMessage(context, "done");
            },
          ),
        ],
      ),
    );
  }

  Widget manColor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Slider(
        value: hue,
        max: 1,
        min: 0,
        onChanged: (value) => setState(() => hue = value),
      ),
    );
  }
}
