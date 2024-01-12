import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/halamanAkunPengguna.dart';
import 'package:pemrograman_mobile/home.dart';
import 'package:pemrograman_mobile/calculator.dart';
import 'package:pemrograman_mobile/profilDeveloper.dart';
import 'package:pemrograman_mobile/profilPengguna.dart';

class navigationbar extends StatefulWidget {
  const navigationbar({super.key});

  @override
  State<navigationbar> createState() => _navigationbarState();
}

class _navigationbarState extends State<navigationbar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 26, 67, 78),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              label: "",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: Icon(Icons.group),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: Icon(Icons.account_circle),
            ),
          ],
          currentIndex: currentIndex,
          onTap: (int index){
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
      body: <Widget>[
        Container(
          child: HomePage(),
        ),
        Container(
          child: HalmanAkunPengguna(),
        ),
        Container(
          child: ProfilPengguna(),
        ),
      ][currentIndex]
    );
  }
}