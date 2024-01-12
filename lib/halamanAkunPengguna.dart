import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HalmanAkunPengguna extends StatefulWidget {
  HalmanAkunPengguna({Key? key}) : super(key: key);

  @override
  _HalmanAkunPenggunaState createState() => _HalmanAkunPenggunaState();
}

class _HalmanAkunPenggunaState extends State<HalmanAkunPengguna> {
  List<Map<String, dynamic>> users = [];

  Future<void> fetchData() async {
    final Uri url = Uri.parse('https://akunmobileku.000webhostapp.com/create.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        users = data.cast<Map<String, dynamic>>();
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(96, 94, 220, 255),   
      body: Padding(
        padding: const EdgeInsets.only(top:60.0, left: 20, right: 20, bottom: 0),
        child: Container(
          child: Column(
            children: [
              Text("PENGGUNA",
              style: TextStyle(
                    color: const Color.fromARGB(255, 26, 67, 78),
                    fontFamily: 'Arial',
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
              ),
              Container(
                height: 668,
                // color: Colors.amber,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: users.length, // Menggunakan panjang list users
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 0, right: 0, left: 0, bottom: 0),
                      child: Container(
                        // color: Colors.grey,
                        width: 250, // Lebar drawer
                        height: 90, // Tinggi drawer
                        margin: EdgeInsets.only(left: 0, top: 10),
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(255, 26, 67, 78),
                                        border: Border.all(width: 1)),
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Padding(padding: EdgeInsets.only(top: 15)),
                                      Container(
                                        width: 200,
                                        height: 25,
                                        child: Text(
                                          users[index]['nama'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Arial',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: Text(
                                          users[index]['nama_lengkap'],
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 55, 55, 55),
                                            fontFamily: 'Arial',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
