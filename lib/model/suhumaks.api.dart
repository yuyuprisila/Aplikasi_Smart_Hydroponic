class Suhumaks {
  final double maksSuhu;

  Suhumaks({
    required this.maksSuhu,
  });

  factory Suhumaks.fromJson(Map<String, dynamic> json) {
    return Suhumaks(
      maksSuhu: double.parse(json['tempC']),
    );
  }
}
