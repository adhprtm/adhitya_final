import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uts_adhityahp/constants/constants.dart';
import 'package:uts_adhityahp/models/attendance_model.dart';
import 'package:uts_adhityahp/utils/utils.dart';
import 'package:uts_adhityahp/services/location_service.dart';

class AttendanceService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  AttendanceModel? attendanceModel;

  String todayDate = DateFormat("dd MMMM yyyy").format(DateTime.now());

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value) {
    notifyListeners();
  }

  String _attendanceHistoryMonth =
      DateFormat('MMMM yyyy').format(DateTime.now());

  String get attendanceHistoryMonth => _attendanceHistoryMonth;

  set attendanceHistoryMonth(String value) {
    _attendanceHistoryMonth = value;
    notifyListeners();
  }

  Future getTodayAttendance() async {
    final List result = await _supabase
        .from(Constants.attendancetable)
        .select()
        .eq("employee_id", _supabase.auth.currentUser!.id)
        .eq('date', todayDate);
    if (result.isNotEmpty) {
      attendanceModel = AttendanceModel.fromJson(result.first);
    }
    notifyListeners();
  }

  Future markAttendance(BuildContext context) async {
    Map? getLocation =
        await LocationService().initializeAndGetLocation(context);
    if (getLocation != null) {
      if (attendanceModel?.checkIn == null) {
        await _supabase.from(Constants.attendancetable).insert({
          'employee_id': _supabase.auth.currentUser!.id,
          'date': todayDate,
          'check_in': DateFormat('HH:mm').format(DateTime.now()),
          'check_in_location': getLocation,
        });
      } else if (attendanceModel?.checkOut == null) {
        await _supabase
            .from(Constants.attendancetable)
            .update({
              'check_out': DateFormat('HH:mm').format(DateTime.now()),
              'check_out_location': getLocation,
            })
            .eq('employee_id', _supabase.auth.currentUser!.id)
            .eq('date', todayDate);
      } else {
        Utils.showSnackBar("Anda Sudah Melakukan Absensi Hari Ini!", context);
      }
      getTodayAttendance();
    } else {
      Utils.showSnackBar("Tidak Bisa Mendapatkan Lokasi Anda", context,
          color: Colors.red);
      getTodayAttendance();
    }
  }

  Future<List<AttendanceModel>> getAttendanceHistory() async {
    final List data = await _supabase
        .from(Constants.attendancetable)
        .select()
        .eq('employee_id', _supabase.auth.currentUser!.id)
        .textSearch('date', "'$attendanceHistoryMonth'", config: 'english')
        .order('created_at', ascending: false);

    return data
        .map((attendance) => AttendanceModel.fromJson(attendance))
        .toList();
  }
}
