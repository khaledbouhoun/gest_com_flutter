class Tva {
  String? TVANO;
  double? TVATAUX;
  String? TVACPTACH;
  String? TVACPTVTE;

  Tva({
    this.TVANO,
    this.TVATAUX,
    this.TVACPTACH,
    this.TVACPTVTE,
  });

  factory Tva.fromJson(Map<String, dynamic> json) {
    return Tva(
      TVANO: json['TVANO'] as String? ?? '',
      TVATAUX: (json['TVATAUX'] as num?)?.toDouble() ?? 0.0,
      TVACPTACH: json['TVACPTACH'] as String? ?? '',
      TVACPTVTE: json['TVACPTVTE'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TVANO': TVANO,
      'TVATAUX': TVATAUX,
      'TVACPTACH': TVACPTACH,
      'TVACPTVTE': TVACPTVTE,
    };
  }

  static List<Tva> listFromJson(List<dynamic> json) {
    return json.map((value) => Tva.fromJson(value)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Tva> tvas) {
    return tvas.map((tva) => tva.toJson()).toList();
  }
}
