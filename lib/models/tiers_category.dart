class TiersCategory {
  String? TRCNO;
  String TRCNOM;
  String TRCSUIV;
  double TRCTYPE;
  double TRCDEFAUT;
  double TRCSELECTAUTO;
  double TRCSELECTAUTO2;
  String TRCCPTHTSTK;
  String TRCCPTTTCSTK;
  String TRCCPTHTSVC;
  String TRCCPTTTCSVC;

  TiersCategory({
    this.TRCNO,
    this.TRCNOM = '',
    this.TRCSUIV = '',
    this.TRCTYPE = 0.0,
    this.TRCDEFAUT = 0.0,
    this.TRCSELECTAUTO = 0.0,
    this.TRCSELECTAUTO2 = 0.0,
    this.TRCCPTHTSTK = '',
    this.TRCCPTTTCSTK = '',
    this.TRCCPTHTSVC = '',
    this.TRCCPTTTCSVC = '',
  });

  factory TiersCategory.fromJson(Map<String, dynamic> json) {
    return TiersCategory(
      TRCNO: json['TRCNO'],
      TRCNOM: json['TRCNOM'] ?? '',
      TRCSUIV: json['TRCSUIV'] ?? '',
      TRCTYPE: (json['TRCTYPE'] ?? 0).toDouble(),
      TRCDEFAUT: (json['TRCDEFAUT'] ?? 0).toDouble(),
      TRCSELECTAUTO: (json['TRCSELECTAUTO'] ?? 0).toDouble(),
      TRCSELECTAUTO2: (json['TRCSELECTAUTO2'] ?? 0).toDouble(),
      TRCCPTHTSTK: json['TRCCPTHTSTK'] ?? '',
      TRCCPTTTCSTK: json['TRCCPTTTCSTK'] ?? '',
      TRCCPTHTSVC: json['TRCCPTHTSVC'] ?? '',
      TRCCPTTTCSVC: json['TRCCPTTTCSVC'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TRCNO': TRCNO,
      'TRCNOM': TRCNOM,
      'TRCSUIV': TRCSUIV,
      'TRCTYPE': TRCTYPE,
      'TRCDEFAUT': TRCDEFAUT,
      'TRCSELECTAUTO': TRCSELECTAUTO,
      'TRCSELECTAUTO2': TRCSELECTAUTO2,
      'TRCCPTHTSTK': TRCCPTHTSTK,
      'TRCCPTTTCSTK': TRCCPTTTCSTK,
      'TRCCPTHTSVC': TRCCPTHTSVC,
      'TRCCPTTTCSVC': TRCCPTTTCSVC,
    };
  }

  static List<TiersCategory> listFromJson(List<dynamic> json) {
    return json.map((e) => TiersCategory.fromJson(e)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<TiersCategory> list) {
    return list.map((e) => e.toJson()).toList();
  }
}
