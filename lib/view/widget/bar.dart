import 'package:flutter/material.dart';
import 'package:traffic_app/constants.dart';

class Bar extends StatelessWidget {
  const Bar({
    Key? key,
    required this.formattedDate,
    required this.date,
    required this.noOfUploads,
    required this.noOfUploadsMax,
  }) : super(key: key);

  final String date;
  final int noOfUploads;
  final int noOfUploadsMax;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 10;
    double width = MediaQuery.of(context).size.width / 10;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            SizedBox(
              height: 50 + height - height * noOfUploads / noOfUploadsMax,
            ),
            Tooltip(
              message: noOfUploads.toString(),
              preferBelow: false,
              verticalOffset: 10 + height * noOfUploads / (noOfUploadsMax * 2),
              waitDuration: const Duration(seconds: 0),
              showDuration: const Duration(seconds: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width * 3 / 16),
                height: height * noOfUploads / noOfUploadsMax + 4,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: noOfUploads == noOfUploadsMax
                      ? themeColor.withOpacity(1)
                      : themeColor.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
        Text(
          date,
          style: subtitleStyle,
        ),
        Text(
          formattedDate,
          style: subtitleStyle,
        ),
      ],
    );
  }
}
