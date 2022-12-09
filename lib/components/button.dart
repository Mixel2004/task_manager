import 'package:flutter/material.dart';

class Button extends FloatingActionButton {
  Button(
      {Key? key,
      IconData icon = Icons.remove,
      Color color = const Color(0xFF303030),
      required Function() onPressed})
      : super(
          key: key,
          onPressed: onPressed,
          child: Icon(icon, color: Colors.white),
          backgroundColor: color,
          elevation: 0,
          heroTag: null,
        );
}
