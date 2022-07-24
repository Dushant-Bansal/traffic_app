import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traffic_app/constants.dart';
import 'package:traffic_app/controller/authController.dart';
import 'package:traffic_app/model/complaint.dart';
import 'package:traffic_app/view/screen/home_screen.dart';
import 'package:traffic_app/view/screen/upload_form.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:traffic_app/view/widget/theme_text_button.dart';

final ImagePicker _picker = ImagePicker();
final storage = FirebaseStorage.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
TextEditingController _controller = TextEditingController();
late DocumentReference<Map<String, dynamic>> _complaintDoc;
late String _downloadUrl;
double rating = 3;
Complaint? _complaint;

class UploadController {
  static void uploadImageFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 40);
      if (file != null) {
        File image = File(file.path);
        Get.to(() => UploadForm(image: image));
      } else {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static void uploadImageFromCamera() async {
    try {
      final XFile? file =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);
      if (file != null) {
        File image = File(file.path);
        Get.to(() => UploadForm(image: image));
      } else {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static void uploadImage(
      {required File image,
      required String location,
      required String vehicleNo,
      String? description}) async {
    try {
      await storage
          .ref()
          .child("images")
          .child("${AuthController.getUserId()}/${DateTime.now()}")
          .putFile(image)
          .then((taskSnapshot) async {
        _downloadUrl = await taskSnapshot.ref.getDownloadURL();
        _complaint = Complaint(
          imageUrl: _downloadUrl,
          location: location,
          vehicleNo: vehicleNo,
          description: description,
          uid: AuthController.getUserId(),
          date: DateFormat.yMMMd().format(DateTime.now()).toString(),
        );
        _complaintDoc =
            await _firestore.collection("complaints").add(_complaint!.toMap());
      }).whenComplete(() {
        Get.offAll(() => const Home());
        Get.dialog(SimpleDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Feedback?',
                style: textStyle,
              ),
              ThemeTextButtonDark(
                text: 'Skip',
                onPressed: () => Get.back(),
              )
            ],
          ),
          children: [
            Center(
              child: RatingBar.builder(
                initialRating: 3,
                itemCount: 5,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      );
                    case 1:
                      return const Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.redAccent,
                      );
                    case 2:
                      return const Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    case 3:
                      return const Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                      );
                    case 4:
                      return const Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      );
                    default:
                      return Container();
                  }
                },
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24.0, top: 12.0, right: 20.0),
                  child: Text(
                    'For Updates:',
                    style: textStyle.copyWith(fontSize: 12.0),
                  ),
                ),
                SizedBox(
                  width: Get.width / 3,
                  child: TextField(
                    controller: _controller,
                    cursorColor: Colors.grey,
                    style: textStyle.copyWith(fontSize: 15.0),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Phone Number',
                      hintStyle: textStyle.copyWith(fontSize: 12.0),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38)),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: ThemeTextButtonDark(
                  text: 'Submit',
                  onPressed: () async {
                    try {
                      _complaintDoc.set(
                          {"rating": rating, "Contact": _controller.text},
                          SetOptions(merge: true)).then((_) => Get.back());
                    } catch (e) {}
                  },
                ),
              ),
            ),
          ],
        ));
      });
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.code);
    }
  }
}
