class AllData {
  final double ntu;
  final double tempC;
  final double waterflow;
  final double created_at;

  AllData({required this.ntu, required this.tempC, required this.waterflow, required this.created_at});

  factory AllData.fromJson(Map<String, dynamic> json) {
    return AllData(
      ntu: double.parse(json['ntu'].toString()),
      tempC: double.parse(json['tempC'].toString()),
      waterflow: double.parse(json['waterflow'].toString()),
      created_at: double.parse(json['created_at'].toString()),
    );
  }

}
