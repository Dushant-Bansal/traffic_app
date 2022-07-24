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
              color: kThemeColor,
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
        backgroundColor: kThemeColor,
        hoverColor: kThemeColor.withOpacity(0.5),
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        color: kThemeColor,
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
                    textStyle: kSubtitleStyle,
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
                      textStyle: kTitleStyle,
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
                style: kTextStyle,
              ),
            ),
            const Stats(),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 3 / 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Uploads',
                    style: kTextStyle,
                  ),
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(kThemeColor),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return kThemeColor.withOpacity(0.04);
                            }
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed)) {
                              return kThemeColor.withOpacity(0.12);
                            }
                            return null;
                          },
                        ),
                      ),
                      onPressed: () => Get.to(() => PhotoViewGallery.builder(
                          itemCount: _imagesList.length,
                          builder: (context, index) {
                            return PhotoViewGalleryPageOptions(
                              imageProvider: NetworkImage(
                                _imagesList[index],
                              ),
                              minScale: PhotoViewComputedScale.contained,
                            );
                          })),
                      child: const Text('View All'))
                ],
              ),
            ),
            Obx(() {
              getImages();
              int length = _imagesList.length < 4 ? _imagesList.length : 4;
              return _imagesList[0].isEmpty && _hasImages.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: kThemeColor,
                      )),
                    )
                  : GridView(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 4 / 80),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing:
                            MediaQuery.of(context).size.width * 1 / 80,
                        mainAxisSpacing:
                            MediaQuery.of(context).size.width * 1 / 80,
                      ),
                      children: List.generate(length, (index) {
                        return _imagesList[index].isEmpty
                            ? Text(
                                'No uploads yet.',
                                style: kSubtitleStyle,
                              )
                            : CachedNetworkImage(
                                imageUrl: _imagesList[index],
                                fit: BoxFit.cover,
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
