import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traffic_app/model/user.dart';
import 'package:traffic_app/view/screen/front_screen.dart';
import 'package:traffic_app/view/screen/home_screen.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
AppUser? _user;

class AuthController {
  static void login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Notification', 'Logged-In Successfully');
      Get.offAll(() => const Home());
    } on FirebaseAuthException catch (e) {
      e.code == 'network-request-failed'
          ? Get.snackbar('No Internet Connection', e.code)
          : Get.snackbar('Error', e.code);
    }
  }

  static void signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.snackbar('Notification', 'Signed-Up Successfully');
      _user = AppUser(name: name, mailId: email, password: password);
      await _firestore.collection("users").add(_user!.toMap());
      await _firestore
          .collection("complaints")
          .doc(AuthController.getUserId())
          .set(_user!.toMap());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(email, name);
      Get.offAll(() => const Home());
    } on FirebaseAuthException catch (e) {
      e.code == 'network-request-failed'
          ? Get.snackbar('No Internet Connection', e.code)
          : Get.snackbar('Error', e.code);
    }
  }

  static void logOut() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
      Get.off(() => const FrontScreen());
      Get.snackbar('Notification', 'Logged-Out Successfully');
    }
  }

  static Future<String> getName() async {
    if (_user != null) {
      return _user!.getName;
    }
    if (_auth.currentUser != null) {
      String name = await _firestore
          .collection("users")
          .where("email", isEqualTo: _auth.currentUser!.email)
          .get()
          .then((value) => value.docs.first["name"]);
      return name;
    } else {
      return 'User';
    }
  }

  static String getEmail() {
    return _auth.currentUser!.email.toString();
  }

  static String getUserId() {
    return _auth.currentUser!.uid.toString();
  }
}
