import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/LineChart_Kualitasair.dart';
import 'package:pemrograman_mobile/chart_kualitasair.dart';
import 'package:pemrograman_mobile/model/turbiavg.api.dart';
import 'package:pemrograman_mobile/model/turbimaks.api.dart';
import 'package:http/http.dart' as http;
import 'package:pemrograman_mobile/model/turbimin.api.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ChartkualitasA extends StatefulWidget {
  const ChartkualitasA({super.key});

  @override
  State<ChartkualitasA> createState() => _ChartKualitasAState();
}

class _ChartKualitasAState extends State<ChartkualitasA> {
  late MqttServerClient client;
  String temperature = 'N/A';
  String turbidity = 'N/A';
  String flowRate = 'N/A';
  
  @override
  void initState() {
    super.initState();
    connectMQTT();
  }

  void connectMQTT() async {
    client = MqttServerClient.withPort('broker.hivemq.com', 'kel6', 1883);

    client.onDisconnected = onDisconnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('kel6') // Ganti dengan identifier klien yang unik
        .keepAliveFor(60) // Tingkatkan jika diperlukan
        .startClean() // Hapus sesi sebelumnya
        .withWillTopic('willtopic') // Topik pesan akan
        .withWillMessage('Will message') // Pesan akan
        .authenticateAs('username', 'password'); // Ganti dengan informasi otentikasi jika diperlukan;

    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print('Client connected');
      subscribeToTopic('iot-hidroponik-kel6'); // Ganti dengan topik yang sesuai
    } else {
      print('Client connection failed - disconnecting, state is ${client.connectionStatus?.state}');
      client.disconnect();
    }
  }

  void subscribeToTopic(String topic) {
    if (client != null && client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.atMostOnce);
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        if (c.isNotEmpty) {
          final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
          final String pt =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          print('GOT A MESSAGE $pt');
          processMessage(pt);
        }
      });
      print('Subscribed to topic: $topic');
    } else {
      print('Client not connected');
    }
  }

  void processMessage(String message) {
    print('Menerima pesan MQTT: $message');

    // Proses dan parsing pesan MQTT di sini
    // Misalnya, jika pesan memiliki format "Temperature: 27.00 ÂºC, Turbidity: 51571.19 NTU, Aliran : 0.00 L/menit"
    List<String> parts = message.split(', ');

    for (String part in parts) {
      if (part.startsWith('Temperature:')) {
        temperature = part.split(' ')[1];
      } else if (part.startsWith('Turbidity:')) {
        turbidity = part.split(' ')[1];
        // updatestring(int.tryParse(turbidity) ?? 0);
      } else if (part.startsWith('Aliran :')) {
        flowRate = part.split(' ')[2];
      }
    }

    // Cetak untuk debugging
    print('Suhu yang diperbarui: $temperature');
    print('Turbidity yang diperbarui: $turbidity');
    print('Aliran yang diperbarui: $flowRate');

    // Jika tidak ada bagian yang sesuai, tetapkan nilai default
    if (temperature == 'N/A') {
      temperature = 'Default'; // Ganti dengan nilai default yang sesuai
    } else if (turbidity == 'N/A') {
      turbidity = 'Default'; // Ganti dengan nilai default yang sesuai
    } else if (flowRate == 'N/A') {
      flowRate = 'Default'; // Ganti dengan nilai default yang sesuai
    }

    setState(() {});
  }



  void onConnected() {
    print('Connected');
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribeFail(String topic) {
    print('Failed to subscribe to $topic');
  }


  String updatestring(int turbiiiiii) {

    print("bisa");
    String kesturbidity = "";
    int turbidityValue = turbiiiiii;

    // Tentukan kondisi dan set variabel kesturbidity
    if (turbidityValue > 60000) {
      kesturbidity = "Bersih";
    } else {
      kesturbidity = "Tidak Bersih";
    }
    return kesturbidity;
  }

  final Turbimaksss turbimakss = Turbimaksss();
  final Turbiminnnn turbiminn = Turbiminnnn();
  final Turbiavgggg suhuavgg = Turbiavgggg();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 67, 78),
      appBar: AppBar(
        title: Text(
          "Chart Kualitas Air",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Arial',
            fontSize: 25,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 26, 67, 78),
        elevation: 0.0,
        toolbarHeight: 70,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [
            Card(
              elevation: 30,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        Container(
                          // color: Colors.black,
                          margin: EdgeInsets.only(left: 5),
                          child: RotatedBox(
                            quarterTurns: -1, // Mengatur jumlah putaran (90 derajat)
                            child: Text(
                              'Kualitas Air',
                              style: TextStyle(fontSize: 15),
                            )
                          )
                        ),
                        Container(
                          // color: Colors.black,
                          child: SizedBox(
                            height: 200,
                            width: 318,
                            child: LineChartKualitasWidget(kualitasAChart),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // color: Colors.black,
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Waktu',
                      style: TextStyle(fontSize: 15),
                    )
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Card(
                        elevation: 30,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15),
                                child: Text(
                                  "Kualitas", 
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "Hari ini", 
                                  style: TextStyle(fontSize: 15,),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 50, right: 10),
                                child: Text(
                                  "$turbidity", 
                                  style: TextStyle(fontSize:20, color: Colors.green[500]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 55),
                                child: Text(
                                  updatestring(int.tryParse(turbidity) ?? 0), 
                                  style: TextStyle(fontSize: 30, color: Colors.green[500]),
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 35)),
                      // Card(
                      //   elevation: 30,
                      //   shadowColor: Colors.black,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(15.0)
                      //   ),
                      //   child: InkWell(
                      //     onTap: (){},
                      //     splashColor: Colors.purple[400],
                      //     child: SizedBox(
                      //       height: 150,
                      //       width: 150,
                      //       child: ListView(
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.only(top: 15, left: 15),
                      //             child: Text(
                      //               "Water", 
                      //               style: TextStyle(fontSize: 25,),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 15),
                      //             child: Text(
                      //               "ON/OFF", 
                      //               style: TextStyle(fontSize: 15,),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(top: 5, left: 50),
                      //             child: Icon(
                      //               Icons.water_drop, 
                      //               color: Colors.purple[400], // Warna ikon
                      //               size: 70, // Ukuran ikon
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //     ),
                      //   ),
                      // ),
                      Card(
                        elevation: 30,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15),
                                child: Text(
                                  "Rata-Rata", 
                                  style: TextStyle(fontSize: 25,),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "Minggu ini", 
                                  style: TextStyle(fontSize: 15,),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 15, left: 55),
                              //   child: Text(
                              //     "30°", 
                              //     style: TextStyle(fontSize: 50, color: Colors.purple[400]),
                              //   ),
                              // )
                              FutureBuilder<List<Turbiavg>>(
                                future: suhuavgg.getPosts(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    // Access the data from the list of Suhumaks objects
                                    List<Turbiavg> suhumaksList = snapshot.data!;
                                    // Now you can use suhumaksList to access its properties
                                    if (suhumaksList.isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 30, left: 25),
                                        child: Text(
                                          '${suhumaksList[0].avgTurbi.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 30, color: Colors.purple[400]),
                                        ),
                                      );
                                    } else {
                                      return Text('No data available');
                                    }
                                  } else {
                                    // Return a default or fallback widget here
                                    return Text('No data available');
                                  }
                                },
                              ),
                            ],
                          )
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Row(
                    children: [
                      Card(
                        elevation: 30,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15),
                                child: Text(
                                  "Kualitas\nTerburuk", 
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "Bulan ini", 
                                  style: TextStyle(fontSize: 15,),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 15, left: 55),
                              //   child: Text(
                              //     "18", 
                              //     style: TextStyle(fontSize: 45, color: Colors.green[500]),
                              //   ),
                              // )
                              FutureBuilder<List<Turbimin>>(
                                future: turbiminn.getPosts(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    // Access the data from the list of Suhumaks objects
                                    List<Turbimin> TurbiminList = snapshot.data!;
                                    // Now you can use TurbiminList to access its properties
                                    if (TurbiminList.isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 50, right: 10),
                                        child: Text(
                                          '${TurbiminList[0].minTurbi.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 35, color: Colors.green[500]),
                                        ),
                                      );
                                    } else {
                                      return Text('No data available');
                                    }
                                  } else {
                                    // Return a default or fallback widget here
                                    return Text('No data available');
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 55),
                                child: Text(
                                  "Keruh", 
                                  style: TextStyle(fontSize: 30, color: Colors.green[500]),
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 35)),
                      Card(
                        elevation: 30,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15),
                                child: Text(
                                  "Kualitas\nTerbaik", 
                                  style: TextStyle(fontSize: 17,),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "Bulan ini", 
                                  style: TextStyle(fontSize: 15,),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 15, left: 90),
                              //   child: Text(
                              //     "8", 
                              //     style: TextStyle(fontSize: 45, color: Colors.purple[400]),
                              //   ),
                              // )
                              FutureBuilder<List<Turbimaks>>(
                                future: turbimakss.getPosts(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    // Access the data from the list of Suhumaks objects
                                    List<Turbimaks> TurbimaksList = snapshot.data!;
                                    // Now you can use TurbimaksList to access its properties
                                    if (TurbimaksList.isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 50, right: 10),
                                        child: Text(
                                          '${TurbimaksList[0].maksTurbi.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 20, color: Colors.purple[400]),
                                        ),
                                      );
                                    } else {
                                      return Text('No data available');
                                    }
                                  } else {
                                    // Return a default or fallback widget here
                                    return Text('No data available');
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 55),
                                child: Text(
                                  updatestring(int.tryParse(turbidity) ?? 0), 
                                  style: TextStyle(fontSize: 30, color: Colors.purple[400]),
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                    ],
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

class Turbimaksss {
  static const String apiUrl = 'https://kel6api.000webhostapp.com/maks_nilai_kekeruhan.php';

  Future<List<Turbimaks>> getPosts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Turbimaks.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

class Turbiminnnn {
  static const String apiUrl = 'https://kel6api.000webhostapp.com/min_nilai_kekeruhan.php';

  Future<List<Turbimin>> getPosts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Turbimin.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

class Turbiavgggg {
  static const String apiUrl = 'https://kel6api.000webhostapp.com/avg_nilai_kekeruhan.php';

  Future<List<Turbiavg>> getPosts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Turbiavg.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}