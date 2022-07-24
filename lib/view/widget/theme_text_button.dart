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

class ThemeTextButtonDark extends StatelessWidget {
  const ThemeTextButtonDark(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black54),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.black54.withOpacity(0.04);
            }
            if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.pressed)) {
              return Colors.black54.withOpacity(0.12);
            }
            return null;
          },
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
