import 'package:flutter/material.dart';
import 'package:module_b/utils/utils.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  TextEditingController controller = TextEditingController();

  OutlineInputBorder boarder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          bgImage(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0.55),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                "Go Skiing",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: controller,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  decoration: InputDecoration(
                    hint: Text(
                      "Player name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    enabledBorder: boarder,
                    focusedBorder: boarder,
                  ),
                ),
              ),
              SizedBox(height: 50),
              button(
                text: "Start Game",
                onTap: () {
                  showMessage(context, "Start Game");
                },
              ),
              SizedBox(height: 20),
              button(
                text: "Rankings",
                onTap: () {
                  showMessage(context, "Rankings");
                },
              ),
              SizedBox(height: 20),
              button(
                text: "Setting",
                onTap: () {
                  showMessage(context, "Setting");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bgImage() => Positioned.fill(
    child: Image.asset(
      "assets/images/bg.jpg",
      fit: BoxFit.cover,
      height: 1500,
      width: 1500,
    ),
  );
}
