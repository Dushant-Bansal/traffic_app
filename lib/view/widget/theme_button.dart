import 'package:flutter/material.dart';
import 'package:traffic_app/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(kThemeColor),
        shadowColor: MaterialStateProperty.all<Color>(kThemeColor),
        elevation: MaterialStateProperty.all<double>(2.0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
        child: Text(
          buttonText,
          style: GoogleFonts.montserrat(
            fontSize: 15.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
