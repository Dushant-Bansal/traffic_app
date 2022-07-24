import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:traffic_app/constants.dart';
import 'package:traffic_app/view/widget/theme_button.dart';
import 'package:traffic_app/view/screen/signup.dart';
import 'package:traffic_app/view/widget/rounded_cover.dart';
import 'package:traffic_app/view/screen/home_screen.dart';
import 'package:get/get.dart';

ImageProvider image = const AssetImage("assets/images/image.jpg");

class FrontScreen extends StatelessWidget {
  const FrontScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FirebaseAuth.instance.currentUser == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 70,
                ),
                Image.asset(
                  "assets/images/image.jpg",
                ),
                Expanded(
                  child: RoundedCover(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Follow up Traffic Rules\nReport about others!',
                                style: kTitleStyle.copyWith(
                                    fontWeight: FontWeight.w800),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                'Never be afraid to stop those\nwho break Traffic Rules',
                                style: kSubtitleStyle,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          ThemeButton(
                            buttonText: 'Get Started',
                            onPressed: () {
                              Get.to(() => const SignUp());
                            },
                          ),
                        ]),
                  ),
                ),
              ],
            )
          : const Home(),
    );
  }
}
