import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:uts_adhityahp/models/user_model.dart';
import 'package:uts_adhityahp/services/attendance_service.dart';
import 'package:uts_adhityahp/services/db_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<SlideActionState> key = GlobalKey<SlideActionState>();

  @override
  void initState() {
    Provider.of<AttendanceService>(context, listen: false).getTodayAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceService = Provider.of<AttendanceService>(context);

    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32, bottom: 10),
            child: const Text(
              "Selamat Datang",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 30),
            ),
          ),
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
          Consumer<DbService>(builder: (context, DbService, child) {
            return FutureBuilder(
                future: DbService.getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserModel user = snapshot.data!;
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        user.name != '' ? user.name : "#${user.employeeId}",
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                            fontSize: 25),
                      ),
                    );
                  }
                  return const SizedBox(
                    width: 60,
                    child: LinearProgressIndicator(),
                  );
                });
          }),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: const Text(
              "Status Hari Ini",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 25),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 32),
            height: 150,
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2)),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Hadir",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      const SizedBox(
                        width: 80,
                        child: Divider(),
                      ),
                      Text(
                        attendanceService.attendanceModel?.checkIn ?? '--/--',
                        style: const TextStyle(fontSize: 25),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Pulang",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      const SizedBox(
                        width: 80,
                        child: Divider(),
                      ),
                      Text(
                        attendanceService.attendanceModel?.checkOut ?? '--/--',
                        style: const TextStyle(fontSize: 25),
                      )
                    ],
                  )),
                ]),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat("dd MMMM yyyy").format(DateTime.now()),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat("hh:mm:ss a").format(DateTime.now()),
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                );
              }),
          Container(
            margin: const EdgeInsets.only(top: 25),
            child: Builder(builder: (context) {
              return SlideAction(
                text: attendanceService.attendanceModel?.checkIn == null
                    ? "Geser untuk Hadir"
                    : "Geser untuk Pulang",
                textStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                ),
                outerColor: Colors.white,
                innerColor: Color.fromARGB(255, 1, 49, 89),
                key: key,
                onSubmit: () async {
                  await attendanceService.markAttendance(context);
                  key.currentState!.reset();
                },
              );
            }),
          ),
        ],
      ),
    ));
  }
}
