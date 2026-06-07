import 'package:flutter/material.dart';

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), duration: Duration(milliseconds: 800)),
  );
}

Widget playImage({double h = 200, double hue = 0.18}) {
  final color = HSVColor.fromAHSV(
    1,
    hue * 360,
    0.7,
    0.9,
  ).toColor().withOpacity(0.2);
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
  required GestureTapCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 18),
      width: 150,
      color: Color(0xff9cd2f8),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

Widget bgImage() {
  return Positioned.fill(
    child: Image.asset(
      "assets/images/bg.jpg",
      fit: BoxFit.cover,
      width: 1500,
      height: 1500,
    ),
  );
}
