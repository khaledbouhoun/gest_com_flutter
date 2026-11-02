class Exercice {
  final int? EXENO;
  final DateTime? EXEDATEDEB;
  final DateTime? EXEDATEFIN;
  final int? EXECLOS;

  Exercice({
    this.EXENO,
    this.EXEDATEDEB,
    this.EXEDATEFIN,
    this.EXECLOS,
  });

  // Convert an Exercice into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toJson() {
    return {
      'EXENO': EXENO,
      'EXEDATEDEB': EXEDATEDEB?.toIso8601String(),
      'EXEDATEFIN': EXEDATEFIN?.toIso8601String(),
      'EXECLOS': EXECLOS,
    };
  }

  // A method that retrieves Exercice from a Map.
  factory Exercice.fromJson(Map<String, dynamic> map) {
    return Exercice(
      EXENO: map['EXENO'],
      EXEDATEDEB: map['EXEDATEDEB'] != null ? DateTime.parse(map['EXEDATEDEB']) : null,
      EXEDATEFIN: map['EXEDATEFIN'] != null ? DateTime.parse(map['EXEDATEFIN']) : null,
      EXECLOS: map['EXECLOS'],
    );
  }

  static List<Map<String, dynamic>> exercicesToJson(List<Exercice> exercices) {
    return exercices.map((exercice) => exercice.toJson()).toList();
  }

  static List<Exercice> exercicesFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Exercice.fromJson(json)).toList();
  }
}
