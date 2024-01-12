class Turbimaks {
  final double maksTurbi;

  Turbimaks({
    required this.maksTurbi,
  });

  factory Turbimaks.fromJson(Map<String, dynamic> json) {
    return Turbimaks(
      maksTurbi: double.parse(json['ntu']),
    );
  }
}
