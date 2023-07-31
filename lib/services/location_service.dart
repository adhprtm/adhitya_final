import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:uts_adhityahp/utils/utils.dart';

class LocationService {
  Location location = Location();
  late LocationData _locData;

  Future<Map<String, double?>?> initializeAndGetLocation(
      BuildContext context) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Cek Lokasi Aktif atau Tidak
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Utils.showSnackBar("Aktifkan Service Lokasi Anda", context);
        return null;
      }
    }
    // Jika Service Aktif, Tanya Permission Lokasi User
    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Utils.showSnackBar("Tolong aktifkan Akses Lokasi", context);
        return null;
      }
    }

    // Permisi Aktif, return koordinat
    _locData = await location.getLocation();
    return {
      'lattitude': _locData.latitude,
      'longitude': _locData.longitude,
    };
  }
}
