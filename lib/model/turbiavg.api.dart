class Turbiavg {
  final double avgTurbi;

  Turbiavg({
    required this.avgTurbi,
  });

  factory Turbiavg.fromJson(Map<String, dynamic> json) {
    return Turbiavg(
      avgTurbi: double.parse(json['ntu']),
    );
  }
}
