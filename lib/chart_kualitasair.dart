import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:pemrograman_mobile/model/alldata.dart';

class KualitasChart {
  final double x;
  final double y;
  KualitasChart({required this.x, required this.y});
}

// List<Map<String, dynamic>> jsonList = jsonDecode();

List<AllData> datafinal = [];

List<KualitasChart>get kualitasAChart{

  final List<double> data = [16,18, 17, 10, 15, 9, 8, 9];
  

  // Menggabungkan data waktu dan suhu menjadi objek SuhuChart
  return data.mapIndexed((index, element) => KualitasChart(x: index.toDouble(), y: element)).toList();
  // return datafinal.map((allData) => KualitasChart(x: allData.created_at, y: allData.ntu)).toList();
  // List<KualitasChart> result = datafinal.map((allData) => KualitasChart(x: allData.created_at, y: allData.ntu)).toList();
  // datafinal.add(allData);
  // print('Data yang digunakan untuk chart: $result');
  // return result;
}


// import 'dart:convert';

// import 'package:collection/collection.dart';
// import 'package:pemrograman_mobile/model/alldata.dart';

// class KualitasChart {
//   final double x;
//   final double y;
//   KualitasChart({required this.x, required this.y});
// }

// List<AllData> datafinal = []; // Isi datafinal sesuai dengan kebutuhan Anda

// List<KualitasChart> get kualitasAChart {
//   // Menggabungkan data waktu dan suhu dari objek AllData menjadi objek KualitasChart
//   return datafinal.map((allData) => KualitasChart(x: allData.created_at, y: allData.ntu)).toList();
// }
