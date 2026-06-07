import 'package:flutter/material.dart';
import 'package:module_b/screen/game_screen.dart';
import 'package:module_b/screen/ranking_screen.dart';
import 'package:module_b/screen/setting_screen.dart';
import 'package:module_b/utils/info.dart';
import 'package:module_b/utils/utils.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  TextEditingController controller = TextEditingController();
  OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          bgImage(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0.6),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Go Skiing",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    disabledBorder: border,
                    focusedBorder: border,
                    enabledBorder: border,
                    border: border,
                    hint: Text(
                      "Player name",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 35),
              button(
                text: "Start Game",
                onTap: () {
                  if (controller.text.trim().isEmpty) {
                    noName();
                    return;
                  } else {
                    setState(() => playerName = controller.text.trim());
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GameScreen(),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 35),
              button(
                text: "Rankings",
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RankingScreen(),
                  ),
                ),
              ),
              SizedBox(height: 35),
              button(
                text: "Setting",
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingScreen(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void noName() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Invalid"),
        content: Text("Please enter your player name"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
