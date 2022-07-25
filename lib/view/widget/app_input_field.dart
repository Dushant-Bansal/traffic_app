import 'package:flutter/material.dart';
import 'package:traffic_app/constants.dart';

class AppInputField extends StatelessWidget {
  final String labelText;
  final bool isObscure;
  final IconData icon;
  final int maxLines;
  final TextEditingController controller;
  final bool required;
  const AppInputField({
    Key? key,
    required this.labelText,
    this.isObscure = false,
    required this.icon,
    required this.controller,
    this.maxLines = 1,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      color: Colors.white,
      child: TextField(
        controller: controller,
        minLines: 1,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          prefixIcon: Icon(icon, color: kThemeColor),
          labelStyle: kTextStyle.copyWith(color: kThemeColor),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: kThemeColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: kThemeColor,
              )),
        ),
        obscureText: isObscure,
      ),
    );
  }
}
