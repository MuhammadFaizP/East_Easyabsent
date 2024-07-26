import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:absensi_flutter/page/absen/absen_page.dart';
import 'package:absensi_flutter/page/leave/leave_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _onWillPop(context);
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 110, 200),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildOptionCard(
                  context,
                  "Absen Kehadiran",
                  'assets/images/ic_absen.png',
                  const AbsenPage(),
                ),
                const SizedBox(height: 40),
                buildOptionCard(
                  context,
                  "Izin",
                  'assets/images/ic_leave.png',
                  const LeavePage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOptionCard(
    BuildContext context,
    String title,
    String imagePath,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 270,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Mont',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 60, 60, 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "INFO",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Apa Anda ingin keluar dari aplikasi?",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  "Batal",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                  "Ya",
                  style: TextStyle(
                    color: Color.fromARGB(255, 112, 129, 255),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
