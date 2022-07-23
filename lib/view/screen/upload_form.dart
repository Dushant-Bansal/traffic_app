import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traffic_app/controller/uploadController.dart';
import 'package:traffic_app/view/screen/home_screen.dart';
import 'package:traffic_app/view/widget/app_input_field.dart';
import 'package:traffic_app/view/widget/theme_button.dart';

final TextEditingController _locationController = TextEditingController();
final TextEditingController _vehicleNoController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
final TextEditingController _mobileNoController = TextEditingController();

class UploadForm extends StatelessWidget {
  const UploadForm({Key? key, required this.image}) : super(key: key);

  final File image;

  @override
  Widget build(BuildContext context) {
    _locationController.clear();
    _vehicleNoController.clear();
    _descriptionController.clear();
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
            child: Image.file(image),
          ),
          AppInputField(
            labelText: 'Vehicle Number*',
            icon: Icons.car_crash,
            controller: _vehicleNoController,
          ),
          AppInputField(
              labelText: 'Location*',
              icon: Icons.location_on_outlined,
              controller: _locationController),
          AppInputField(
              labelText: 'Description',
              icon: Icons.description,
              maxLines: 7,
              controller: _descriptionController),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ThemeButton(
                buttonText: 'Submit',
                onPressed: () {
                  UploadController.uploadImage(
                    image: image,
                    location: _locationController.text,
                    vehicleNo: _vehicleNoController.text,
                    description: _descriptionController.text,
                  );
                }),
          )
        ],
      ),
    );
  }
}
