class Turbimin {
  final double minTurbi;

  Turbimin({
    required this.minTurbi,
  });

  factory Turbimin.fromJson(Map<String, dynamic> json) {
    return Turbimin(
      minTurbi: double.parse(json['ntu']),
    );
  }
}
