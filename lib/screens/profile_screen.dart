import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_adhityahp/services/auth_service.dart';
import 'package:uts_adhityahp/services/db_service.dart';
import 'package:uts_adhityahp/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final dbService = Provider.of<DbService>(context);

    return Scaffold(
      body: FutureBuilder<UserModel>(
        future: dbService.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Tidak Ada User'));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 32, bottom: 10),
                  child: const Text(
                    "Profil Pegawai",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontSize: 30,
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('icon/profil.png'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name != '' ? user.name : "#${user.employeeId}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Marketing",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            authService.signOut();
                          },
                          tooltip: 'Keluar',
                          iconSize: 30,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(0),
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          splashRadius: 24,
                          color: Colors.red,
                          splashColor: Colors.white,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          mouseCursor: SystemMouseCursors.click,
                          enableFeedback: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
