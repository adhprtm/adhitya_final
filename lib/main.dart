import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uts_adhityahp/models/attendance_model.dart';
import 'package:uts_adhityahp/screens/login_screen.dart';
import 'package:uts_adhityahp/screens/splash_screen.dart';
import 'package:uts_adhityahp/services/attendance_service.dart';
import 'package:uts_adhityahp/services/auth_service.dart';
import 'package:uts_adhityahp/services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //load env
  await dotenv.load();
  //init supabase
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => DbService()),
        ChangeNotifierProvider(create: (context) => AttendanceService()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Absensi Pegawai',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SplashScreen()),
    );
  }
}
