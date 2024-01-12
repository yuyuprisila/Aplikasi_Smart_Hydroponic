class SuhuAvg {
  final double avgSuhu;

  SuhuAvg({
    required this.avgSuhu,
  });

  factory SuhuAvg.fromJson(Map<String, dynamic> json) {
    return SuhuAvg(
      avgSuhu: double.parse(json['tempC']),
    );
  }
}
