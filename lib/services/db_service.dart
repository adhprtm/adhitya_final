import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uts_adhityahp/constants/constants.dart';
import 'package:uts_adhityahp/models/user_model.dart';

class DbService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  UserModel? userModel;

  String generateRandomEmployeeId() {
    final random = Random();
    const allChars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789";
    final randomString =
        List.generate(8, (index) => allChars[random.nextInt(allChars.length)])
            .join();
    return randomString;
  }

  Future insertNewUser(String email, var id) async {
    await _supabase.from(Constants.employeeTable).insert({
      'id': id,
      'name': '',
      'email': email,
      'employee_id': generateRandomEmployeeId(),
      'department': null,
    });
  }

  Future<UserModel> getUserData() async {
    final UserData = await _supabase
        .from(Constants.employeeTable)
        .select()
        .eq('id', _supabase.auth.currentUser!.id)
        .single();
    userModel = UserModel.fromJson(UserData);
    return userModel!;
  }
}