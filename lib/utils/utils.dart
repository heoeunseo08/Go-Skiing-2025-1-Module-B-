import 'package:flutter/material.dart';

class Utils {}

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
