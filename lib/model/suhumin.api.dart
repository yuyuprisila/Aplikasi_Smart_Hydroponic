class Suhumin {
  final String minSuhu;

  Suhumin({
    required this.minSuhu,
  });

  factory Suhumin.fromJson(Map<String, dynamic> json) {
    return Suhumin(
      minSuhu: json['tempC'],
    );
  }
}
