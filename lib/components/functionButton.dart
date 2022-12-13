import 'package:flutter/material.dart';

class FunctionButton extends StatelessWidget {
  final Function() onPressed;
  final Text text;
  final Color? color;

  const FunctionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: text,
          ),
        ),
      ),
    );
  }
}
