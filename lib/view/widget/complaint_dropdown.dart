import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traffic_app/constants.dart';
import 'app_input_field.dart';

List<String> complaints = [
  "Accident Related Offence",
  "Blocking emergency vehicles",
  "Custom",
  "Drunken driving",
  "Driving on Footpath",
  "Jumped traffic light",
  "No Parking",
  "Not Wearing Seatbelt",
  "Not Wearing Helmet",
  "Offences by Juveniles",
  "One Way/ No Entry",
  "Overloading",
  "Over Pollution",
  "Over Speeding",
  "Rash Driving",
  "Seat belt",
  "UnderAge"
];

final TextEditingController _descriptionController = TextEditingController();

class ComplaintDropDown extends StatefulWidget {
  const ComplaintDropDown({Key? key, required this.isIOS}) : super(key: key);

  final bool isIOS;
  @override
  State<ComplaintDropDown> createState() => ComplaintDropDownState();
}

class ComplaintDropDownState extends State<ComplaintDropDown> {
  static String dropdownValue = complaints[0];

  @override
  void initState() {
    super.initState();
    dropdownValue = complaints[0];
    _descriptionController.clear();
  }

  static String getComplaint() {
    if (dropdownValue == 'Custom') {
      return 'Custom: ${_descriptionController.text}';
    }
    return dropdownValue;
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        dropdownValue == 'Custom'
            ? AppInputField(
                labelText: 'Description',
                icon: Icons.description,
                maxLines: 7,
                controller: _descriptionController)
            : Container(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
          child: widget.isIOS
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Complaint:',
                    style: kTextStyle.copyWith(color: kThemeColor),
                  ),
                  CupertinoButton(
                    child: Text(
                      dropdownValue,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    onPressed: () => _showDialog(
                      CupertinoPicker(
                          itemExtent: 32.0,
                          onSelectedItemChanged: (selectedIndex) {
                            setState(() {
                              dropdownValue = complaints[selectedIndex];
                            });
                          },
                          children: complaints.map<Text>((String value) {
                            return Text(value);
                          }).toList()),
                    ),
                  )
                ])
              : DropdownButton(
                  value: dropdownValue,
                  items: complaints.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        dropdownValue = newValue!;
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
