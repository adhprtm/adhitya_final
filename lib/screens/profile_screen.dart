import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_adhityahp/models/department_model.dart';
import 'package:uts_adhityahp/services/auth_service.dart';
import 'package:uts_adhityahp/services/db_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);

    dbService.allDepartments.isEmpty ? dbService.getAllDepartments() : null;
    nameController.text.isEmpty
        ? nameController.text = dbService.userModel?.name ?? ''
        : null;

    return Scaffold(
      body: dbService.userModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.topRight,
                      child: TextButton.icon(
                          onPressed: () {
                            Provider.of<AuthService>(context, listen: false)
                                .signOut();
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text("Keluar")),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 100,
                      width: 100,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icon/profil.png',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text("Nomor Pegawai : ${dbService.userModel?.employeeId}"),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          label: Text("Nama Lengkap"),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    dbService.allDepartments.isEmpty
                        ? const LinearProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                              value: dbService.employeeDepartment ??
                                  dbService.allDepartments.first.id,
                              items: dbService.allDepartments
                                  .map((DepartmentModel item) {
                                return DropdownMenuItem(
                                  value: item.id,
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                );
                              }).toList(),
                              onChanged: (selectedValue) {
                                dbService.employeeDepartment = selectedValue;
                              },
                            ),
                          ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            dbService.updateProfile(
                                nameController.text.trim(), context);
                          },
                          child: const Text(
                            "Perbarui Profil",
                            style: TextStyle(fontSize: 20),
                          )),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
