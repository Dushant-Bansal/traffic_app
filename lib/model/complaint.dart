class Complaint {
  Complaint({
    required this.uid,
    required this.imageUrl,
    this.location,
    this.vehicleNo,
    this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "imageUrl": imageUrl,
        "location": location,
        "vehicleNo": vehicleNo,
        "description": description,
        "time": date
      };

  final String imageUrl;
  final String? uid;
  final String? location;
  final String? vehicleNo;
  final String? description;
  final String date;
}
