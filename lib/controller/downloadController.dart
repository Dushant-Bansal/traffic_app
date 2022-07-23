import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:traffic_app/controller/authController.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DownloadController {
  static Future<List<String>> getImages() async {
    if (_auth.currentUser == null) {
      return [''];
    }
    List<String> _imagesList = [];
    final _storageRef = FirebaseStorage.instance
        .ref()
        .child("images/${AuthController.getUserId()}");
    final imagesList = await _storageRef.listAll();
    for (var item in imagesList.items) {
      _imagesList.add(await item.getDownloadURL());
    }
    _imagesList = _imagesList.toSet().toList();
    return _imagesList;
  }

  static Future<int> getNumberofUploads(String date) async {
    if (_auth.currentUser == null) {
      return 0;
    }
    int uploads = await _firestore
        .collection("complaints")
        .where("uid", isEqualTo: AuthController.getUserId())
        .where("time", isEqualTo: date)
        .get()
        .then((value) => value.docs.length);
    return uploads;
  }
}
