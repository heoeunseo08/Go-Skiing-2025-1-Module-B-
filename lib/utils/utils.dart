import 'package:flutter/material.dart';

Widget playerImage({double h = 200, double hue = 0.18}) {
  final color = HSVColor.fromAHSV(1, hue * 360, 0.7, 0.9).toColor();
  return Stack(
    children: [
      Image.asset("assets/images/skiing_person.png", height: h),
      Positioned.fill(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.modulate),
          child: Image.asset("assets/images/skiing_person.png", height: h),
        ),
      ),
    ],
  );
}

Widget button({
  required String text,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      color: Color(0xff9cd2f8),
      width: 150,
      height: 60,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
    ),
  );
}

void showMessage(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(milliseconds: 700),
      ),
    );
