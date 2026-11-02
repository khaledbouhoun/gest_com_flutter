class Ville {
  final String VILPAYS;
  final String VILTERR;
  final String VILNO;
  final String? VILNOM; // Nullable field for VILNOM

  Ville({
    required this.VILPAYS,
    required this.VILTERR,
    required this.VILNO,
    this.VILNOM,
  });

  factory Ville.fromJson(Map<String, dynamic> json) {
    return Ville(
      VILPAYS: json['VILPAYS'] ?? '',
      VILTERR: json['VILTERR'] ?? '',
      VILNO: json['VILNO'] ?? '',
      VILNOM: json['VILNOM'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'VILPAYS': VILPAYS,
      'VILTERR': VILTERR,
      'VILNO': VILNO,
      'VILNOM': VILNOM,
    };
  }

  static List<Ville> villesFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Ville.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> villesToJson(List<Ville> villes) {
    return villes.map((ville) => ville.toJson()).toList();
  }
}
