import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traffic_app/constants.dart';
import 'package:traffic_app/controller/downloadController.dart';
import 'package:traffic_app/view/widget/bar.dart';
import 'package:intl/intl.dart' show DateFormat;

RxList<int> _noOfUploads = [0, 0, 0, 0, 0, 0, 0].obs;
RxInt _noOfUploadsMax = 1.obs;
RxInt _noOfUploadsToday = 0.obs;
RxBool isLoaded = false.obs;

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  void getNoOfUploads() async {
    for (int i = 0; i < 7; i++) {
      String date = DateFormat.yMMMd()
          .format(DateTime.now().subtract(Duration(days: i)))
          .toString();
      _noOfUploads[i] = await DownloadController.getNumberofUploads(date);
    }
    _noOfUploadsToday.value = _noOfUploads[0];
    isLoaded.value = true;
  }

  static void init() {
    _noOfUploads = [0, 0, 0, 0, 0, 0, 0].obs;
    _noOfUploadsMax = 1.obs;
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Column(
      children: [
        Obx(
          () => Text(
            '$_noOfUploadsToday',
            style: const TextStyle(
              fontSize: 60.0,
              letterSpacing: -4,
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          'Interaction from '
          '${DateTime.now().subtract(const Duration(days: 6)).day} '
          '${DateFormat.MMM().format(DateTime.now().subtract(const Duration(days: 6)))} '
          '- ${DateTime.now().day} ${DateFormat.MMM().format(DateTime.now())}',
          style: subtitleStyle,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          child: Padding(
            padding:
                EdgeInsets.all(MediaQuery.of(context).size.width * 3 / 160),
            child: Obx(() {
              getNoOfUploads();
              for (int i in _noOfUploads) {
                _noOfUploadsMax.value =
                    _noOfUploadsMax.value > i ? _noOfUploadsMax.value : i;
              }
              return isLoaded.value
                  ? ListView.builder(
                      itemCount: 7,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) => Bar(
                        date: DateTime.now()
                            .subtract(Duration(days: index))
                            .day
                            .toString(),
                        formattedDate: DateFormat.MMM().format(
                            DateTime.now().subtract(Duration(days: index))),
                        noOfUploads: _noOfUploads[index],
                        noOfUploadsMax: _noOfUploadsMax.value,
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: themeColor,
                      ),
                    );
            }),
          ),
        ),
      ],
    );
  }
}
