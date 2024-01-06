import 'package:flutter/material.dart';

class SquareGradientButton extends StatelessWidget {
  final Function(BuildContext) onPress;
  final String text;
  final List<Color> colors;
  final double height;

  const SquareGradientButton({super.key, required this.onPress, required this.text, required this.colors, required this.height});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {onPress(context);},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          height: height,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

class SquareGradientButtonSizeable extends StatelessWidget {
  final Function(BuildContext) onPress;
  final String text;
  final List<Color> colors;
  final Size size;

  const SquareGradientButtonSizeable({super.key, required this.onPress, required this.text, required this.colors, required this.size});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {onPress(context);},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}