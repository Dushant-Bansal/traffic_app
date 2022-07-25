import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String> getLocation(double latitude, double longitude) async {
  late List<Placemark> placemarks;
  try {
    placemarks = await placemarkFromCoordinates(latitude, longitude);
  } catch (e) {}
  return '${placemarks[0]},\nCoordinates: [$latitude, $longitude]';
}

Future<String?> getLatLong() async {
  await Geolocator.requestPermission();
  LocationPermission permissionCheck = await Geolocator.checkPermission();
  if (permissionCheck == LocationPermission.denied ||
      permissionCheck == LocationPermission.deniedForever) {
    return null;
  }
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String address = await getLocation(position.latitude, position.longitude);
    return address;
  } catch (e) {
    return null;
  }
}
