

class TarifEntate {
  String TFENO;
  DateTime? TFEDATE;
  String TFENOM;
  double TFEACTIF;
  double TFETYPE;
  double TFEMARGE;
  double TFEBASE;
  
  

  TarifEntate({
    this.TFENO = '',
    this.TFEDATE,
    this.TFENOM = '',
    this.TFEACTIF = 0.0,
    this.TFETYPE = 0.0,
    this.TFEMARGE = 0.0,
    this.TFEBASE = 0.0,
  });

  factory TarifEntate.fromJson(Map<String, dynamic> json) {
    return TarifEntate(
      TFENO: json['TFENO'] ?? '',
      TFEDATE: json['TFEDATE'] != null ? DateTime.parse(json['TFEDATE']) : null,
      TFENOM: json['TFENOM'] ?? '',
      TFEACTIF: (json['TFEACTIF'] as num?)?.toDouble() ?? 0.0,
      TFETYPE: (json['TFETYPE'] as num?)?.toDouble() ?? 0.0,
      TFEMARGE: (json['TFEMARGE'] as num?)?.toDouble() ?? 0.0,
      TFEBASE: (json['TFEBASE'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TFENO': TFENO,
      'TFEDATE': TFEDATE?.toIso8601String(),
      'TFENOM': TFENOM,
      'TFEACTIF': TFEACTIF,
      'TFETYPE': TFETYPE,
      'TFEMARGE': TFEMARGE,
      'TFEBASE': TFEBASE,
    };
  }

  static List<TarifEntate> listFromJson(List<dynamic> json) {
    return json.map((e) => TarifEntate.fromJson(e as Map<String, dynamic>)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<TarifEntate> list) {
    return list.map((e) => e.toJson()).toList();
  }
}


