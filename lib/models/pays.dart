class Pays {
  final String PYSNO;
  final String PYSNOM;
  final String PYSNATION;
  final String PYSINDICATIF;

  Pays({
    required this.PYSNO,
    required this.PYSNOM,
    required this.PYSNATION,
    required this.PYSINDICATIF,
  });

  factory Pays.fromJson(Map<String, dynamic> json) {
    return Pays(
      PYSNO: json['PYSNO'] ?? '',
      PYSNOM: json['PYSNOM'] ?? '',
      PYSNATION: json['PYSNATION'] ?? '',
      PYSINDICATIF: json['PYSINDICATIF'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PYSNO': PYSNO,
      'PYSNOM': PYSNOM,
      'PYSNATION': PYSNATION,
      'PYSINDICATIF': PYSINDICATIF,
    };
  }

  static List<Pays> paysFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Pays.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> paysToJson(List<Pays> pays) {
    return pays.map((pays) => pays.toJson()).toList();
  }
}
