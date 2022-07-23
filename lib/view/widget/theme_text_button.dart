import 'package:flutter/material.dart';
import 'package:traffic_app/constants.dart';

class ThemeTextButton extends StatelessWidget {
  const ThemeTextButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(
            const Color(0xFFA89BEA).withOpacity(0.07)),
      ),
      child: Text(
        text,
        style: titleStyle.copyWith(
            fontWeight: FontWeight.normal, fontSize: 16.0, letterSpacing: -0.7),
      ),
    );
  }
}
