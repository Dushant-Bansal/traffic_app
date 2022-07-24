import 'package:traffic_app/constants.dart';
import 'package:traffic_app/view/screen/login.dart';
import 'package:traffic_app/view/widget/theme_text_button.dart';
import 'package:flutter/material.dart';
import 'package:traffic_app/controller/authController.dart';
import 'package:traffic_app/view/widget/app_input_field.dart';
import 'package:traffic_app/view/widget/theme_button.dart';
import 'package:get/get.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passController = TextEditingController();

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    nameController.clear();
    emailController.clear();
    passController.clear();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Register',
                    style: kTitleStyle.copyWith(
                        color: kThemeColor,
                        fontSize: 40.0,
                        letterSpacing: -0.7)),
                const SizedBox(height: 50.0),
                AppInputField(
                  labelText: 'Name',
                  icon: Icons.person,
                  controller: nameController,
                ),
                AppInputField(
                  labelText: 'Email',
                  icon: Icons.email,
                  controller: emailController,
                ),
                AppInputField(
                  labelText: 'Password',
                  icon: Icons.password,
                  isObscure: true,
                  controller: passController,
                ),
                const SizedBox(height: 50.0),
                ThemeButton(
                  buttonText: 'Sign Up',
                  onPressed: () {
                    AuthController.signUp(
                      name: nameController.text,
                      email: emailController.text,
                      password: passController.text,
                    );
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ThemeTextButton(
              text: 'Already have an account',
              onPressed: () {
                Get.to(() => const Login());
              },
            ),
          ),
        ],
      ),
    );
  }
}
