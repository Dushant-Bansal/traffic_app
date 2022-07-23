import 'dart:io' show InternetAddress, SocketException;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:traffic_app/view/widget/theme_button.dart';
import 'firebase_options.dart';
import 'package:traffic_app/view/screen/front_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

RxBool activeConnection = false.obs;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        activeConnection.value = true;
      }
    } on SocketException catch (_) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar('Notification', 'No Internet Connection');
      }
      activeConnection.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Obx(() {
        checkUserConnection();
        return activeConnection.value
            ? const FrontScreen()
            : Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/images/no_internet.png'),
                    ThemeButton(
                        buttonText: 'Refresh',
                        onPressed: () {
                          checkUserConnection();
                        })
                  ],
                ),
              );
      }),
    );
  }
}
