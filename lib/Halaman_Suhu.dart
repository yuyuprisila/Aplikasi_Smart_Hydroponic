import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Hydroponic/LineChart_Suhu.dart';
import 'package:Hydroponic/chart_suhu.dart';
import 'package:http/http.dart' as http;
import 'package:Hydroponic/model/suhuavg.api.dart';
import 'package:Hydroponic/model/suhumaks.api.dart';
import 'package:Hydroponic/model/suhumin.api.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Chartsuhu extends StatefulWidget {
  const Chartsuhu({super.key});

  @override
  State<Chartsuhu> createState() => _ChartsuhuState();
}

class _ChartsuhuState extends State<Chartsuhu> {
  // Future<Suhumaks?>? Suhumakss;
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
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
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

  final Suhumakssss suhumakss = Suhumakssss();
  final Suhuminnn suhuminn = Suhuminnn();
  final Suhuavgggg suhuavgg = Suhuavgggg();

  @override
  Widget build(BuildContext context) {
    // client.subscribe('iot-hidroponik-kel6', MqttQos.atLeastOnce); // Subscribe to the weather updates topic
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 67, 78),
      appBar: AppBar(
        title: Text(
          "Chart Suhu",
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
                              'Celcius',
                              style: TextStyle(fontSize: 15),
                            )
                          )
                        ),
                        Container(
                          // color: Colors.black,
                          child: SizedBox(
                            height: 200,
                            width: 318,
                            child: LineChartWidget(suhuChart),
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
                                  "Suhu", 
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
                                padding: const EdgeInsets.only(top: 30, left: 25),
                                child: Text(
                                  '$temperature °C', 
                                  style: TextStyle(fontSize: 30, color: Colors.green[500]),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 15, left: 55),
                              //   child: Text(
                              //     '$temperature', 
                              //     style: TextStyle(fontSize: 50, color: Colors.green[500]),
                              //   ),
                              // ),
                              // StreamBuilder<List<MqttReceivedMessage<MqttMessage>>>(
                              //   stream: client.updates,
                              //   builder: (context, snapshot) {
                              //     if (!snapshot.hasData) {
                              //       return CircularProgressIndicator();
                              //     }

                              //     final updates = snapshot.data!;
                              //     if (updates.isEmpty) {
                              //       return Center(child: Text('Tidak ada data'));
                              //     }

                              //     final latestUpdate = updates.last.payload as MqttPublishMessage?;
                              //     if (latestUpdate == null) {
                              //       return Center(child: Text('Error: Unable to retrieve weather update.'));
                              //     }

                              //     final String payload =
                              //         MqttPublishPayload.bytesToStringAsString(latestUpdate.payload.message);
                              //     final List<String> updateParts = payload.split(', ');

                              //     String temperature = updateParts[0].split(': ')[1];
                              //     String turbidity = updateParts[1].split(': ')[1];
                              //     String flowRate = updateParts[2].split(': ')[1];

                              //     return Padding(
                              //       padding: const EdgeInsets.only(top: 15, left: 55),
                              //       child: Text(
                              //         '$temperature', 
                              //         style: TextStyle(fontSize: 50, color: Colors.green[500]),
                              //       ),
                              //     );
                              //   },
                              // ),
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
                              FutureBuilder<List<SuhuAvg>>(
                                future: suhuavgg.getPosts(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    // Access the data from the list of Suhumaks objects
                                    List<SuhuAvg> suhumaksList = snapshot.data!;
                                    // Now you can use suhumaksList to access its properties
                                    if (suhumaksList.isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 30, left: 25),
                                        child: Text(
                                          '${suhumaksList[0].avgSuhu.toStringAsFixed(2)}°C',
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
                                  "Min", 
                                  style: TextStyle(fontSize: 25),
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
                              //     "27°", 
                              //     style: TextStyle(fontSize: 50, color: Colors.green[500]),
                              //   ),
                              // )
                              FutureBuilder<List<Suhumin>>(
                                future: suhuminn.getPosts(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    // Access the data from the list of Suhumaks objects
                                    List<Suhumin> suhuminList = snapshot.data!;
                                    // Now you can use suhuminList to access its properties
                                    if (suhuminList.isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 30, left: 25),
                                        child: Text(
                                          '${suhuminList[0].minSuhu}°',
                                          style: TextStyle(fontSize: 30, color: Colors.green[500]),
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
                                  "Max", 
                                  style: TextStyle(fontSize: 25,),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "Bulan ini", 
                                  style: TextStyle(fontSize: 15,),
                                ),
                              ),
                              FutureBuilder<List<Suhumaks>>(
                                future: suhumakss.getPosts(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    // Access the data from the list of Suhumaks objects
                                    List<Suhumaks> suhumaksList = snapshot.data!;
                                    // Now you can use suhumaksList to access its properties
                                    if (suhumaksList.isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 30, left: 25),
                                        child: Text(
                                          '${suhumaksList[0].maksSuhu.toStringAsFixed(2)}°',
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
                ],
              ),
            )
          ],
        ),
      ), 
    );
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}

Widget buildDataWidget(context, snapshot) => Padding(
  padding: const EdgeInsets.only(top: 15, left: 55),
  child: Text(
    'Temperature: ${snapshot.data!.maksSuhu.toStringAsFixed(2)}°',
    style: TextStyle(fontSize: 50, color: Colors.purple[400]),
  ),
);



// Future<Suhumaks> fetchPost() async {
//   final uri = Uri.parse("https://kel6api.000webhostapp.com/maks_nilai_suhu.php");
//   final response = await http.get(uri);

//   print('API Response: ${response.body}');

//   if (response.statusCode == 200){
//     return Suhumaks.fromJson(json.decode(response.body));
//   } else {
//     throw Exception('Failed to load post');
//   }
// }

class Suhumakssss {
  static const String apiUrl = 'https://kel6api.000webhostapp.com/maks_nilai_suhu.php';

  Future<List<Suhumaks>> getPosts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Suhumaks.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

class Suhuminnn {
  static const String apiUrl = 'https://kel6api.000webhostapp.com/min_nilai_suhu.php';

  Future<List<Suhumin>> getPosts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Suhumin.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

class Suhuavgggg {
  static const String apiUrl = 'https://kel6api.000webhostapp.com/avg_nilai_suhu.php';

  Future<List<SuhuAvg>> getPosts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SuhuAvg.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}