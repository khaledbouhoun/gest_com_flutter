class Transaction {
  String JNLCPT;
  String JNLNO;
  DateTime JNLDATE;
  String JNLSOURCE;
  String JNLJOU;
  String JNLRUB;
  int JNLSENS;
  double JNLTYPE;
  String JNLTIERS;
  String JNLSITE;
  String JNLTRFNO;
  String JNLTRFCPT;
  String JNLCODESEL;
  String JNLMDP;
  String MDPNOM;
  String ETBABV;
  double JNLDEBIT;
  double JNLCREDIT;
  String JNLDESC;
  String CPTNOM;
  String CPTABV;
  String RUBNOM;
  double RUBNIVEAU;
  double RUBPERE;
  String TIERSNOM;
  String TIERSPRENOM;
  double NATGENRE;
  String NATABV;
  String MISSION;
  String CHAUFFEUR;
  String CptNomArr;
  String CptABVArr;
  String JnlRef;
  int JnlValideArr;
  double InstTRF;
  String TneNo;
  Transaction({
    required this.JNLCPT,
    required this.JNLNO,
    required this.JNLDATE,
    required this.JNLSOURCE,
    required this.JNLJOU,
    required this.JNLRUB,
    required this.JNLSENS,
    required this.JNLTYPE,
    required this.JNLTIERS,
    required this.JNLSITE,
    required this.JNLTRFNO,
    required this.JNLTRFCPT,
    required this.JNLCODESEL,
    required this.JNLMDP,
    required this.MDPNOM,
    required this.ETBABV,
    required this.JNLDEBIT,
    required this.JNLCREDIT,
    required this.JNLDESC,
    required this.CPTNOM,
    required this.CPTABV,
    required this.RUBNOM,
    required this.RUBNIVEAU,
    required this.RUBPERE,
    required this.TIERSNOM,
    required this.TIERSPRENOM,
    required this.NATGENRE,
    required this.NATABV,
    required this.MISSION,
    required this.CHAUFFEUR,
    this.CptNomArr = '',
    this.CptABVArr = '',
    this.JnlRef = '',
    this.JnlValideArr = 0,
    this.InstTRF = 0.0,
    this.TneNo = '   th   th',
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      JNLCPT: json['JNLCPT'] ?? '',
      JNLNO: json['JNLNO'] ?? '',
      JNLDATE: json['JNLDATE'] != null ? DateTime.parse(json['JNLDATE']) : DateTime.now(),
      JNLSOURCE: json['JNLSOURCE'] ?? '',
      JNLJOU: json['JNLJOU'] ?? '',
      JNLRUB: json['JNLRUB'] ?? '',
      JNLSENS: (json['JNLSENS'] as num?)?.toInt() ?? 0,
      JNLTYPE: (json['JNLTYPE'] as num?)?.toDouble() ?? 0.0,
      JNLTIERS: json['JNLTIERS'] ?? '',
      JNLSITE: json['JNLSITE'] ?? '',
      JNLTRFNO: json['JNLTRFNO'] ?? '',
      JNLTRFCPT: json['JNLTRFCPT'] ?? '',
      JNLCODESEL: json['JNLCODESEL'] ?? '',
      JNLMDP: json['JNLMDP'] ?? '',
      MDPNOM: json['MDPNOM'] ?? '',
      ETBABV: json['ETBABV'] ?? '',
      JNLDEBIT: (json['JNLDEBIT'] as num?)?.toDouble() ?? 0.0,
      JNLCREDIT: (json['JNLCREDIT'] as num?)?.toDouble() ?? 0.0,
      JNLDESC: json['JNLDESC'] ?? '',
      CPTNOM: json['CPTNOM'] ?? '',
      CPTABV: json['CPTABV'] ?? '',
      RUBNOM: json['RUBNOM'] ?? '',
      RUBNIVEAU: (json['RUBNIVEAU'] as num?)?.toDouble() ?? 0.0,
      RUBPERE: (json['RUBPERE'] as num?)?.toDouble() ?? 0.0,
      TIERSNOM: json['TIERSNOM'] ?? '',
      TIERSPRENOM: json['TIERSPRENOM'] ?? '',
      NATGENRE: (json['NATGENRE'] as num?)?.toDouble() ?? 0.0,
      NATABV: json['NATABV'] ?? '',
      MISSION: json['MISSION'] ?? '',
      CHAUFFEUR: json['CHAUFFEUR'] ?? '',
      CptNomArr: json['CptNomArr'] ?? json['CPTNOMARR'] ?? '',
      CptABVArr: json['CptABVArr'] ?? json['CPTABVARR'] ?? '',
      JnlRef: json['JnlRef'] ?? json['JNLREF'] ?? '',
      JnlValideArr: ((json['JnlValideArr'] ?? json['JNLVALIDEARR']) as num?)?.toInt() ?? 0,
      InstTRF: ((json['InstTRF'] ?? json['INSTTRF']) as num?)?.toDouble() ?? 0.0,
      TneNo: json['TneNo'] ?? json['TNENO'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JNLCPT': JNLCPT,
      'JNLNO': JNLNO,
      'JNLDATE': JNLDATE.toIso8601String(),
      'JNLSOURCE': JNLSOURCE,
      'JNLJOU': JNLJOU,
      'JNLRUB': JNLRUB,
      'JNLSENS': JNLSENS,
      'JNLTYPE': JNLTYPE,
      'JNLTIERS': JNLTIERS,
      'JNLSITE': JNLSITE,
      'JNLTRFNO': JNLTRFNO,
      'JNLTRFCPT': JNLTRFCPT,
      'JNLCODESEL': JNLCODESEL,
      'JNLMDP': JNLMDP,
      'MDPNOM': MDPNOM,
      'ETBABV': ETBABV,
      'JNLDEBIT': JNLDEBIT,
      'JNLCREDIT': JNLCREDIT,
      'JNLDESC': JNLDESC,
      'CPTNOM': CPTNOM,
      'CPTABV': CPTABV,
      'RUBNOM': RUBNOM,
      'RUBNIVEAU': RUBNIVEAU,
      'RUBPERE': RUBPERE,
      'TIERSNOM': TIERSNOM,
      'TIERSPRENOM': TIERSPRENOM,
      'NATGENRE': NATGENRE,
      'NATABV': NATABV,
      'MISSION': MISSION,
      'CHAUFFEUR': CHAUFFEUR,
      'CptNomArr': CptNomArr,
      'CptABVArr': CptABVArr,
      'JnlRef': JnlRef,
      'JnlValideArr': JnlValideArr,
      'InstTRF': InstTRF,
      'TneNo': TneNo,
    };
  }

  static List<Transaction> listFromJson(List<dynamic> jsonList, int sens) {
    return jsonList.map((json) => Transaction.fromJson(json)).where((e) => sens == 2 || e.JNLSENS == sens).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Transaction> transactions) {
    return transactions.map((transaction) => transaction.toJson()).toList();
  }

  TransactionStatus get status {
    switch (JNLSENS) {
      case 0:
        return TransactionStatus.debit;
      case 1:
        return TransactionStatus.credit;
      case 2:
        return TransactionStatus.all;
      default:
        return TransactionStatus.all;
    }
  }
}

enum TransactionStatus {
  debit,
  credit,
  all,
}
