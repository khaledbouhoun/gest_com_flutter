class FactureEntate {
  final DateTime FTEDATE;
  final DateTime? FTECDEDATE;
  final String FTECDENO;
  final String FTECLI;
  final double FTETYPE;
  final double FTEMNTHT;
  final double FTEMNTTVA;
  final double FTEMNTTTC;
  final double FTETREM;
  final double FTEREMISE;
  final double FTENAP;
  final double FTEREGLE;
  final double FTESOLDE;
  final List<double> FTENOTES;
  final DateTime? FTEDHCRE;
  final DateTime? FTEDHMOD;
  final double FTEVALIDE;
  final DateTime? FTEDATEVAL;
  final String FTESITE;
  final double FTEREGLEMENT;
  final String FTECPT;
  final String FTERUB;
  final String FTEDESC;
  final DateTime? FTEDHIMPR;
  final double FTETYPEREM;
  final double FTECOUTG;
  final double FTEMARGE;
  final String FTENOOR;
  final String FTEJNL;
  final String FTELIVREPAR;
  final String FTECREPAR;
  final String FTEMODPAR;
  final String FTEVALPAR;
  final String FTEIMPRPAR;
  final String FTETNENO;
  final DateTime? FTEDHREGL;
  final String FTEREGLPAR;
  final String FTEMDP;
  final String FTEREF;
  final String FTEETAT;
  final DateTime? FTEDATEECH;
  final String FTEBANQUE;
  final String FTEAGENCE;
  final String FTECOMPTE;
  final double FTETOTBASE;
  final double FTEMRGBASE;
  final double FTEESPMNT;
  final DateTime? FTEESPDATE;
  final String FTEESPNO;
  final double FTECHQMNT;
  final DateTime? FTECHQDATE;
  final String FTECHQNO;
  final String FTETRANSPORTEUR;
  final double FTEINSTANCE;
  final double FTEDELAIPAYE;
  final String FTECATEG;
  final double FTETIMBRE;
  final String FTECODESEL;
  final String FTENOBC;
  final DateTime? FTESRCDATE;
  final DateTime? FTEDESTDATE;
  final String? FTELIVREPAR2;
  final String? FTELIVREPAR3;
  final String? FTELIVREPAR4;
  final String? FTELIVREPAR5;
  final double FTETOTPOIDS;
  final String FTENO;
  final String FTEDESTNO;
  final String FTESRCNO;
  final double FTETXCOMMIS;
  final double FTEMNTCOMMIS;
  final double FTETYPECOMMIS;
  final double FTEVERROU;
  final String? FTEDERNOUVERPAR;
  final DateTime? FTEDHDERNOUVER;
  final double FTEESPECES;
  final double FTERENDU;
  final String CLINOM;
  final String CLIPRENOM;
  final String CLITEL1;

  FactureEntate({
    required this.FTEDATE,
    this.FTECDEDATE,
    this.FTECDENO = '',
    this.FTECLI = '',
    this.FTETYPE = 0.0,
    this.FTEMNTHT = 0.0,
    this.FTEMNTTVA = 0.0,
    this.FTEMNTTTC = 0.0,
    this.FTETREM = 0.0,
    this.FTEREMISE = 0.0,
    this.FTENAP = 0.0,
    this.FTEREGLE = 0.0,
    this.FTESOLDE = 0.0,
    this.FTENOTES = const [],
    this.FTEDHCRE,
    this.FTEDHMOD,
    this.FTEVALIDE = 0.0,
    this.FTEDATEVAL,
    this.FTESITE = '',
    this.FTEREGLEMENT = 0.0,
    this.FTECPT = '',
    this.FTERUB = '',
    this.FTEDESC = '',
    this.FTEDHIMPR,
    this.FTETYPEREM = 0.0,
    this.FTECOUTG = 0.0,
    this.FTEMARGE = 0.0,
    this.FTENOOR = '',
    this.FTEJNL = '',
    this.FTELIVREPAR = '',
    this.FTECREPAR = '',
    this.FTEMODPAR = '',
    this.FTEVALPAR = '',
    this.FTEIMPRPAR = '',
    this.FTETNENO = '',
    this.FTEDHREGL,
    this.FTEREGLPAR = '',
    this.FTEMDP = '',
    this.FTEREF = '',
    this.FTEETAT = '',
    this.FTEDATEECH,
    this.FTEBANQUE = '',
    this.FTEAGENCE = '',
    this.FTECOMPTE = '',
    this.FTETOTBASE = 0.0,
    this.FTEMRGBASE = 0.0,
    this.FTEESPMNT = 0.0,
    this.FTEESPDATE,
    this.FTEESPNO = '',
    this.FTECHQMNT = 0.0,
    this.FTECHQDATE,
    this.FTECHQNO = '',
    this.FTETRANSPORTEUR = '',
    this.FTEINSTANCE = 0.0,
    this.FTEDELAIPAYE = 0.0,
    this.FTECATEG = '',
    this.FTETIMBRE = 0.0,
    this.FTECODESEL = '',
    this.FTENOBC = '',
    this.FTESRCDATE,
    this.FTEDESTDATE,
    this.FTELIVREPAR2,
    this.FTELIVREPAR3,
    this.FTELIVREPAR4,
    this.FTELIVREPAR5,
    this.FTETOTPOIDS = 0.0,
    required this.FTENO,
    required this.FTEDESTNO,
    required this.FTESRCNO,
    this.FTETXCOMMIS = 0.0,
    this.FTEMNTCOMMIS = 0.0,
    this.FTETYPECOMMIS = 0.0,
    this.FTEVERROU = 0.0,
    this.FTEDERNOUVERPAR,
    this.FTEDHDERNOUVER,
    this.FTEESPECES = 0.0,
    this.FTERENDU = 0.0,
    this.CLINOM = '',
    this.CLIPRENOM = '',
    this.CLITEL1 = '',
  });

  factory FactureEntate.fromJson(Map<String, dynamic> json) {
    return FactureEntate(
      FTEDATE: DateTime.parse(json['FTEDATE']).add(Duration(hours: 2)),
      FTECDEDATE: json['FTECDEDATE'] != null ? DateTime.parse(json['FTECDEDATE']) : null,
      FTECDENO: json['FTECDENO'] ?? '',
      FTECLI: json['FTECLI'] ?? '',
      FTETYPE: (json['FTETYPE'] as num?)?.toDouble() ?? 0.0,
      FTEMNTHT: (json['FTEMNTHT'] as num?)?.toDouble() ?? 0.0,
      FTEMNTTVA: (json['FTEMNTTVA'] as num?)?.toDouble() ?? 0.0,
      FTEMNTTTC: (json['FTEMNTTTC'] as num?)?.toDouble() ?? 0.0,
      FTETREM: (json['FTETREM'] as num?)?.toDouble() ?? 0.0,
      FTEREMISE: (json['FTEREMISE'] as num?)?.toDouble() ?? 0.0,
      FTENAP: (json['FTENAP'] as num?)?.toDouble() ?? 0.0,
      FTEREGLE: (json['FTEREGLE'] as num?)?.toDouble() ?? 0.0,
      FTESOLDE: (json['FTESOLDE'] as num?)?.toDouble() ?? 0.0,
      FTENOTES: json['FTENOTES'] != null ? List<double>.from(json['FTENOTES']) : const [],
      FTEDHCRE: json['FTEDHCRE'] != null ? DateTime.parse(json['FTEDHCRE']) : null,
      FTEDHMOD: json['FTEDHMOD'] != null ? DateTime.parse(json['FTEDHMOD']) : null,
      FTEVALIDE: (json['FTEVALIDE'] as num?)?.toDouble() ?? 0.0,
      FTEDATEVAL: json['FTEDATEVAL'] != null ? DateTime.parse(json['FTEDATEVAL']) : null,
      FTESITE: json['FTESITE'] ?? '',
      FTEREGLEMENT: (json['FTEREGLEMENT'] as num?)?.toDouble() ?? 0.0,
      FTECPT: json['FTECPT'] ?? '',
      FTERUB: json['FTERUB'] ?? '',
      FTEDESC: json['FTEDESC'] ?? '',
      FTEDHIMPR: json['FTEDHIMPR'] != null ? DateTime.parse(json['FTEDHIMPR']) : null,
      FTETYPEREM: (json['FTETYPEREM'] as num?)?.toDouble() ?? 0.0,
      FTECOUTG: (json['FTECOUTG'] as num?)?.toDouble() ?? 0.0,
      FTEMARGE: (json['FTEMARGE'] as num?)?.toDouble() ?? 0.0,
      FTENOOR: json['FTENOOR'] ?? '',
      FTEJNL: json['FTEJNL'] ?? '',
      FTELIVREPAR: json['FTELIVREPAR'] ?? '',
      FTECREPAR: json['FTECREPAR'] ?? '',
      FTEMODPAR: json['FTEMODPAR'] ?? '',
      FTEVALPAR: json['FTEVALPAR'] ?? '',
      FTEIMPRPAR: json['FTEIMPRPAR'] ?? '',
      FTETNENO: json['FTETNENO'] ?? '',
      FTEDHREGL: json['FTEDHREGL'] != null ? DateTime.parse(json['FTEDHREGL']) : null,
      FTEREGLPAR: json['FTEREGLPAR'] ?? '',
      FTEMDP: json['FTEMDP'] ?? '',
      FTEREF: json['FTEREF'] ?? '',
      FTEETAT: json['FTEETAT'] ?? '',
      FTEDATEECH: json['FTEDATEECH'] != null ? DateTime.parse(json['FTEDATEECH']) : null,
      FTEBANQUE: json['FTEBANQUE'] ?? '',
      FTEAGENCE: json['FTEAGENCE'] ?? '',
      FTECOMPTE: json['FTECOMPTE'] ?? '',
      FTETOTBASE: (json['FTETOTBASE'] as num?)?.toDouble() ?? 0.0,
      FTEMRGBASE: (json['FTEMRGBASE'] as num?)?.toDouble() ?? 0.0,
      FTEESPMNT: (json['FTEESPMNT'] as num?)?.toDouble() ?? 0.0,
      FTEESPDATE: json['FTEESPDATE'] != null ? DateTime.parse(json['FTEESPDATE']) : null,
      FTEESPNO: json['FTEESPNO'] ?? '',
      FTECHQMNT: (json['FTECHQMNT'] as num?)?.toDouble() ?? 0.0,
      FTECHQDATE: json['FTECHQDATE'] != null ? DateTime.parse(json['FTECHQDATE']) : null,
      FTECHQNO: json['FTECHQNO'] ?? '',
      FTETRANSPORTEUR: json['FTETRANSPORTEUR'] ?? '',
      FTEINSTANCE: (json['FTEINSTANCE'] as num?)?.toDouble() ?? 0.0,
      FTEDELAIPAYE: (json['FTEDELAIPAYE'] as num?)?.toDouble() ?? 0.0,
      FTECATEG: json['FTECATEG'] ?? '',
      FTETIMBRE: (json['FTETIMBRE'] as num?)?.toDouble() ?? 0.0,
      FTECODESEL: json['FTECODESEL'] ?? '',
      FTENOBC: json['FTENOBC'] ?? '',
      FTESRCDATE: json['FTESRCDATE'] != null ? DateTime.parse(json['FTESRCDATE']) : null,
      FTEDESTDATE: json['FTEDESTDATE'] != null ? DateTime.parse(json['FTEDESTDATE']) : null,
      FTELIVREPAR2: json['FTELIVREPAR2'],
      FTELIVREPAR3: json['FTELIVREPAR3'],
      FTELIVREPAR4: json['FTELIVREPAR4'],
      FTELIVREPAR5: json['FTELIVREPAR5'],
      FTETOTPOIDS: (json['FTETOTPOIDS'] as num?)?.toDouble() ?? 0.0,
      FTENO: json['FTENO'] ?? '',
      FTEDESTNO: json['FTEDESTNO'] ?? '',
      FTESRCNO: json['FTESRCNO'] ?? '',
      FTETXCOMMIS: (json['FTETXCOMMIS'] as num?)?.toDouble() ?? 0.0,
      FTEMNTCOMMIS: (json['FTEMNTCOMMIS'] as num?)?.toDouble() ?? 0.0,
      FTETYPECOMMIS: (json['FTETYPECOMMIS'] as num?)?.toDouble() ?? 0.0,
      FTEVERROU: (json['FTEVERROU'] as num?)?.toDouble() ?? 0.0,
      FTEDERNOUVERPAR: json['FTEDERNOUVERPAR'],
      FTEDHDERNOUVER: json['FTEDHDERNOUVER'] != null ? DateTime.parse(json['FTEDHDERNOUVER']) : null,
      FTEESPECES: (json['FTEESPECES'] as num?)?.toDouble() ?? 0.0,
      FTERENDU: (json['FTERENDU'] as num?)?.toDouble() ?? 0.0,
      CLINOM: json['CLINOM'] ?? '',
      CLIPRENOM: json['CLIPRENOM'] ?? '',
      CLITEL1: json['CLITEL1'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FTEDATE': FTEDATE.toIso8601String(),
      'FTECDEDATE': FTECDEDATE?.toIso8601String(),
      'FTECDENO': FTECDENO,
      'FTECLI': FTECLI,
      'FTETYPE': FTETYPE,
      'FTEMNTHT': FTEMNTHT,
      'FTEMNTTVA': FTEMNTTVA,
      'FTEMNTTTC': FTEMNTTTC,
      'FTETREM': FTETREM,
      'FTEREMISE': FTEREMISE,
      'FTENAP': FTENAP,
      'FTEREGLE': FTEREGLE,
      'FTESOLDE': FTESOLDE,
      'FTENOTES': FTENOTES,
      'FTEDHCRE': FTEDHCRE?.toIso8601String(),
      'FTEDHMOD': FTEDHMOD?.toIso8601String(),
      'FTEVALIDE': FTEVALIDE,
      'FTEDATEVAL': FTEDATEVAL?.toIso8601String(),
      'FTESITE': FTESITE,
      'FTEREGLEMENT': FTEREGLEMENT,
      'FTECPT': FTECPT,
      'FTERUB': FTERUB,
      'FTEDESC': FTEDESC,
      'FTEDHIMPR': FTEDHIMPR?.toIso8601String(),
      'FTETYPEREM': FTETYPEREM,
      'FTECOUTG': FTECOUTG,
      'FTEMARGE': FTEMARGE,
      'FTENOOR': FTENOOR,
      'FTEJNL': FTEJNL,
      'FTELIVREPAR': FTELIVREPAR,
      'FTECREPAR': FTECREPAR,
      'FTEMODPAR': FTEMODPAR,
      'FTEVALPAR': FTEVALPAR,
      'FTEIMPRPAR': FTEIMPRPAR,
      'FTETNENO': FTETNENO,
      'FTEDHREGL': FTEDHREGL?.toIso8601String(),
      'FTEREGLPAR': FTEREGLPAR,
      'FTEMDP': FTEMDP,
      'FTEREF': FTEREF,
      'FTEETAT': FTEETAT,
      'FTEDATEECH': FTEDATEECH?.toIso8601String(),
      'FTEBANQUE': FTEBANQUE,
      'FTEAGENCE': FTEAGENCE,
      'FTECOMPTE': FTECOMPTE,
      'FTETOTBASE': FTETOTBASE,
      'FTEMRGBASE': FTEMRGBASE,
      'FTEESPMNT': FTEESPMNT,
      'FTEESPDATE': FTEESPDATE?.toIso8601String(),
      'FTEESPNO': FTEESPNO,
      'FTECHQMNT': FTECHQMNT,
      'FTECHQDATE': FTECHQDATE?.toIso8601String(),
      'FTECHQNO': FTECHQNO,
      'FTETRANSPORTEUR': FTETRANSPORTEUR,
      'FTEINSTANCE': FTEINSTANCE,
      'FTEDELAIPAYE': FTEDELAIPAYE,
      'FTECATEG': FTECATEG,
      'FTETIMBRE': FTETIMBRE,
      'FTECODESEL': FTECODESEL,
      'FTENOBC': FTENOBC,
      'FTESRCDATE': FTESRCDATE?.toIso8601String(),
      'FTEDESTDATE': FTEDESTDATE?.toIso8601String(),
      'FTELIVREPAR2': FTELIVREPAR2,
      'FTELIVREPAR3': FTELIVREPAR3,
      'FTELIVREPAR4': FTELIVREPAR4,
      'FTELIVREPAR5': FTELIVREPAR5,
      'FTETOTPOIDS': FTETOTPOIDS,
      'FTENO': FTENO,
      'FTEDESTNO': FTEDESTNO,
      'FTESRCNO': FTESRCNO,
      'FTETXCOMMIS': FTETXCOMMIS,
      'FTEMNTCOMMIS': FTEMNTCOMMIS,
      'FTETYPECOMMIS': FTETYPECOMMIS,
      'FTEVERROU': FTEVERROU,
      'FTEDERNOUVERPAR': FTEDERNOUVERPAR,
      'FTEDHDERNOUVER': FTEDHDERNOUVER?.toIso8601String(),
      'FTEESPECES': FTEESPECES,
      'FTERENDU': FTERENDU,
      'CLINOM': CLINOM,
      'CLIPRENOM': CLIPRENOM,
      'CLITEL1': CLITEL1,
    };
  }

  static List<FactureEntate> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => FactureEntate.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<FactureEntate> list) {
    return list.map((factureEntete) => factureEntete.toJson()).toList();
  }
}
