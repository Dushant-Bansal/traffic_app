import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traffic_app/controller/authController.dart';
import 'package:flutter/material.dart';
import 'package:traffic_app/constants.dart';
import 'package:get/get.dart';
import 'package:traffic_app/controller/downloadController.dart';
import 'package:traffic_app/controller/uploadController.dart';
import 'package:traffic_app/view/screen/stats.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

String _time = DateTime.now().hour > 12 ? 'Evening' : 'Morning';
RxString userName = ''.obs;
RxList<String> _imagesList = [''].obs;
RxBool _hasImages = true.obs;

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String email = FirebaseAuth.instance.currentUser.toString();
    userName.value = prefs.getString(email) ?? await AuthController.getName();
  }

  void getImages() async {
    _imagesList.value = await DownloadController.getImages();
    if (_imagesList.isEmpty) {
      _imagesList.add('');
      _hasImages.value = false;
    } else {
      _imagesList.value = _imagesList.reversed.toList();
    }
  }

  void init() {
    try {
      _imagesList.value = [''];
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: themeColor,
            ),
            onPressed: () {
              AuthController.logOut();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UploadController.uploadImageFromGallery();
          Get.back();
        },
        backgroundColor: themeColor,
        hoverColor: themeColor.withOpacity(0.5),
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        color: themeColor,
        displacement: 0,
        onRefresh: () {
          init();
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: SafeArea(
            child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 3 / 80),
              child: Text('Good $_time',
                  style: GoogleFonts.comfortaa(
                    textStyle: subtitleStyle,
                  )),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 3 / 80),
              child: Obx(() {
                getUserName();
                return Text(userName.value,
                    style: GoogleFonts.comfortaa(
                      letterSpacing: -1,
                      fontSize: GetPlatform.isIOS ? 28.0 : 20.0,
                      fontWeight: FontWeight.w800,
                      textStyle: titleStyle,
                    ));
              }),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 3 / 80),
              child: Text(
                'Stats',
                style: textStyle,
              ),
            ),
            const Stats(),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 3 / 80),
              child: Text(
                'Uploads',
                style: textStyle,
              ),
            ),
            Obx(() {
              getImages();
              return _imagesList[0].isEmpty && _hasImages.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: themeColor,
                      )),
                    )
                  : GridView(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 4 / 80),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _imagesList[0].isEmpty ? 2 : 3,
                        crossAxisSpacing:
                            MediaQuery.of(context).size.width * 1 / 80,
                        mainAxisSpacing:
                            MediaQuery.of(context).size.width * 1 / 80,
                      ),
                      children: List.generate(_imagesList.length, (index) {
                        return _imagesList[index].isEmpty
                            ? Text(
                                'No uploads yet.',
                                style: subtitleStyle,
                              )
                            : GestureDetector(
                                onTap: () =>
                                    Get.to(() => PhotoViewGallery.builder(
                                        itemCount: _imagesList.length,
                                        builder: (context, index) {
                                          return PhotoViewGalleryPageOptions(
                                            imageProvider: NetworkImage(
                                              _imagesList[index],
                                            ),
                                            minScale: PhotoViewComputedScale
                                                .contained,
                                          );
                                        })),
                                child: CachedNetworkImage(
                                  imageUrl: _imagesList[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                      }),
                    );
            }),
            const SizedBox(
              height: 10,
            ),
          ],
        )),
      ),
    );
  }
}
