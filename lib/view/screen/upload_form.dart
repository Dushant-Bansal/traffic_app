import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:traffic_app/constants.dart';
import 'package:traffic_app/controller/locationController.dart';
import 'package:traffic_app/controller/uploadController.dart';
import 'package:traffic_app/view/widget/app_input_field.dart';
import 'package:traffic_app/view/widget/complaint_dropdown.dart';
import 'package:traffic_app/view/widget/theme_button.dart';

final TextEditingController _locationController = TextEditingController();
final TextEditingController _vehicleNoController = TextEditingController();
final TextEditingController _mobileNoController = TextEditingController();

class UploadForm extends StatelessWidget {
  const UploadForm({Key? key, required this.image}) : super(key: key);

  final File image;

  @override
  Widget build(BuildContext context) {
    void getLocationAgain() async {
      try {
        _locationController.text = (await getLatLong())!;
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Error accessing Location.'),
          action: SnackBarAction(
            label: 'RETRY',
            textColor: kThemeColor,
            onPressed: () => getLocationAgain(),
          ),
        ));
      }
    }

    _locationController.clear();
    _vehicleNoController.clear();
    _mobileNoController.clear();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Image.file(image),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.download,
                      color: kThemeColor,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      GallerySaver.saveImage(image.path).whenComplete(
                        () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Downloaded'))),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          AppInputField(
            labelText: 'Vehicle Number*',
            icon: Icons.car_crash,
            controller: _vehicleNoController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: AppInputField(
                    labelText: 'Location*',
                    icon: Icons.location_on_outlined,
                    maxLines: 4,
                    controller: _locationController),
              ),
              Expanded(
                child: IconButton(
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.gps_fixed),
                    color: kThemeColor,
                    splashColor: const Color(0xFFA89BEA).withOpacity(0.07),
                    onPressed: () async {
                      try {
                        _locationController.text = (await getLatLong())!;
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Error accessing Location.'),
                          action: SnackBarAction(
                            label: 'RETRY',
                            textColor: kThemeColor,
                            onPressed: () => getLocationAgain(),
                          ),
                        ));
                      }
                    }),
              )
            ],
          ),
          ComplaintDropDown(isIOS: GetPlatform.isIOS),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ThemeButton(
                buttonText: 'Submit',
                onPressed: () {
                  _vehicleNoController.text.isEmpty
                      ? ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please Input Vehicle No.')))
                      : _locationController.text.isEmpty
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please Input Location')))
                          : Get.dialog(Center(
                              child: CircularProgressIndicator(
                              color: kThemeColor,
                            )));
                  if (_vehicleNoController.text.isNotEmpty &&
                      _locationController.text.isNotEmpty) {
                    UploadController.uploadImage(
                      image: image,
                      location: _locationController.text.trim(),
                      vehicleNo: _vehicleNoController.text,
                      description: ComplaintDropDownState.getComplaint(),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
