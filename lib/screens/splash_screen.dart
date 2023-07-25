import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_adhityahp/screens/home_screen.dart';
import 'package:uts_adhityahp/screens/login_screen.dart';
import 'package:uts_adhityahp/services/auth_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return authService.currentUser == null
        ? const LoginScreen()
        : const HomeScreen();
  }
}
