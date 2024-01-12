//stf
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  TextEditingController angka1 =TextEditingController();
  TextEditingController angka2 =TextEditingController();
  TextEditingController hasil =TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Padding(padding: EdgeInsets.only(top: 40.0),),
            TextField(
              controller: angka1,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Warna biru saat aktif
                ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(50),
                  borderSide: new BorderSide(color: Colors.white)
                ),
                filled: true,
                labelText: "Angka Pertama",
                labelStyle: TextStyle(color:  Colors.black),
                hintText: "Masukkan angka pertama",
                fillColor: const Color.fromARGB(255, 235, 250, 239),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: angka2,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Warna biru saat aktif
                ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(50),
                  borderSide: new BorderSide(color: Colors.white)
                ),
                filled: true,
                labelText: "Angka Kedua",
                labelStyle: TextStyle(color:  Colors.black),
                hintText: "Masukkan angka Kedua",
                fillColor: const Color.fromARGB(255, 235, 250, 239),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                hasil.text,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ), //Textstyle
              ),
            ), 
            // TextField(
            //   controller: hasil,
            //   decoration: InputDecoration(
            //     labelText: "Hasil"
            //   ),
            // ),
            Container(
              padding: EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Aksi yang ingin Anda lakukan saat tombol ditekan
                      hasil.text = (double.parse(angka1.text)+double.parse(angka2.text)).toString();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 63, 194, 255), // Warna latar belakang tombol
                      onPrimary: Colors.white, // Warna teks tombol (saat tombol tidak aktif)
                      fixedSize: Size(160, 50),
                    ),
                    child: Text('Tambah', style: TextStyle(fontFamily: 'Roboto'),),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Aksi yang ingin Anda lakukan saat tombol ditekan
                      hasil.text = (double.parse(angka1.text)-double.parse(angka2.text)).toString();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 63, 194, 255), // Warna latar belakang tombol
                      onPrimary: Colors.white, // Warna teks tombol (saat tombol tidak aktif)
                      fixedSize: Size(160, 50),
                    ),
                    child: Text('Kurang', style: TextStyle(fontFamily: 'Roboto'),),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Aksi yang ingin Anda lakukan saat tombol ditekan
                      hasil.text = (double.parse(angka1.text)/double.parse(angka2.text)).toString();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 63, 194, 255), // Warna latar belakang tombol
                      onPrimary: Colors.white, // Warna teks tombol (saat tombol tidak aktif)
                      fixedSize: Size(160, 50),
                    ),
                    child: Text('Bagi', style: TextStyle(fontFamily: 'Roboto'),),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Aksi yang ingin Anda lakukan saat tombol ditekan
                      hasil.text = (double.parse(angka1.text)*double.parse(angka2.text)).toString();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 63, 194, 255), // Warna latar belakang tombol
                      onPrimary: Colors.white, // Warna teks tombol (saat tombol tidak aktif)
                      fixedSize: Size(160, 50),
                    ),
                    child: Text('Kali', style: TextStyle(fontFamily: 'Roboto'),),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}