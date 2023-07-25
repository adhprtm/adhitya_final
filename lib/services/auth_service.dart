import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uts_adhityahp/services/db_service.dart';
import '../utils/utils.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DbService _dbService = DbService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future registerEmployee(
      String email, String password, BuildContext context) async {
    try {
      setIsLoading = true;
      if (email == "" || password == "") {
        throw ("Semua Kolom Wajib Diisi!");
      }
      final AuthResponse response =
          await _supabase.auth.signUp(email: email, password: password);
      if (response != null) {
        await _dbService.insertNewUser(email, response.user!.id);

        Utils.showSnackBar("Berhasil! Anda telah Terdaftar", context,
            color: Color.fromARGB(255, 9, 130, 13));
        await loginEmployee(email, password, context);
        Navigator.pop(context);
      }
    } catch (e) {
      setIsLoading = false;
      Utils.showSnackBar(e.toString(), context,
          color: Color.fromARGB(255, 255, 17, 0));
    }
  }

  Future loginEmployee(
      String email, String password, BuildContext context) async {
    try {
      setIsLoading = true;
      if (email == "" || password == "") {
        throw ("Semua Kolom Wajib Diisi!");
      }
      final AuthResponse response = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      setIsLoading = false;
    } catch (e) {
      setIsLoading = false;
      Utils.showSnackBar(e.toString(), context,
          color: Color.fromARGB(255, 255, 17, 0));
    }
  }

  Future signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }

  User? get currentUser => _supabase.auth.currentUser;
}
