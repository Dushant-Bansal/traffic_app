import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traffic_app/controller/authController.dart';
import 'package:traffic_app/model/complaint.dart';
import 'package:traffic_app/view/screen/home_screen.dart';
import 'package:traffic_app/view/screen/upload_form.dart';
import 'package:intl/intl.dart' show DateFormat;

final ImagePicker _picker = ImagePicker();
final storage = FirebaseStorage.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
Complaint? _complaint;

class UploadController {
  static void uploadImageFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 80);
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
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
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
      String? location,
      String? vehicleNo,
      String? description}) async {
    try {
      File compressedImage = await FlutterNativeImage.compressImage(image.path);
      await storage
          .ref()
          .child("images")
          .child("${AuthController.getUserId()}/${DateTime.now()}")
          .putFile(compressedImage)
          .then((taskSnapshot) async {
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        _complaint = Complaint(
          imageUrl: downloadUrl,
          location: location,
          vehicleNo: vehicleNo,
          description: description,
          uid: AuthController.getUserId(),
          date: DateFormat.yMMMd().format(DateTime.now()).toString(),
        );
        await _firestore.collection("complaints").add(_complaint!.toMap());
      }).whenComplete(() => Get.offAll(() => const Home()));
      Get.snackbar('Notification', 'Image Uploaded Successfully');
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.code);
    }
  }
}
