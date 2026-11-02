class Territoire {
  final String TERPAYS;
  final String TERNO;
  final String? TERNOM; // Nullable field for TERNOM

  Territoire({
    required this.TERPAYS,
    required this.TERNO,
    this.TERNOM,
  });

  factory Territoire.fromJson(Map<String, dynamic> json) {
    return Territoire(
      TERPAYS: json['TERPAYS'] ?? '',
      TERNO: json['TERNO'] ?? '',
      TERNOM: json['TERNOM'].replaceAll('в','â').replaceAll('п','ï').replaceAll('й','é').replaceAll('и','è') ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TERPAYS': TERPAYS,
      'TERNO': TERNO,
      'TERNOM': TERNOM
    };
  }

  static List<Territoire> territoiresFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Territoire.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> territoiresToJson(List<Territoire> territories) {
    return territories.map((territore) => territore.toJson()).toList();
  }
}
