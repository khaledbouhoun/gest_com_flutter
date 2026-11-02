class ReceptionEntate {
  DateTime? FTEDATE;
  String FTENO;
  DateTime? FTECDEDATE;
  String? FTECDENO;
  String FTEFOU;
  double FTETYPE;
  double FTEMNTHT;
  double FTEMNTTVA;
  double FTEMNTTTC;
  double FTETREM;
  double FTEREMISE;
  double FTENAP;
  double FTEREGLE;
  double FTESOLDE;
  String? FTENOTES; // BLOB SUB_TYPE BINARY
  DateTime? FTEDHCRE;
  DateTime? FTEDHMOD;
  double FTEVALIDE;
  DateTime? FTEDATEVAL;
  double FTEREGLEMENT;
  String? FTECPT;
  String? FTERUB;
  String? FTEDESC;
  DateTime? FTEDHIMPR;
  double FTETYPEREM;
  String? FTEREF;
  String? FTEJNL;
  String? FTECREPAR;
  String? FTEMODPAR;
  String? FTEVALPAR;
  String? FTEIMPRPAR;
  DateTime? FTEDHREGL;
  String? FTEREGLPAR;
  String? FTECODESEL;
  double FTEFRAISACC;
  double FTETIMBRE;
  String? FTECATEG;
  double FTEVERROU;
  String? FTEDERNOUVERPAR;
  DateTime? FTEDHDERNOUVER;
  String? FOUNOM;
  String? FOUPRENOM;
  String? FOUTEL1;

  ReceptionEntate({
    this.FTEDATE,
    this.FTENO = '',
    this.FTECDEDATE,
    this.FTECDENO = '',
    this.FTEFOU = '',
    this.FTETYPE = 0.0,
    this.FTEMNTHT = 0.0,
    this.FTEMNTTVA = 0.0,
    this.FTEMNTTTC = 0.0,
    this.FTETREM = 0.0,
    this.FTEREMISE = 0.0,
    this.FTENAP = 0.0,
    this.FTEREGLE = 0.0,
    this.FTESOLDE = 0.0,
    this.FTENOTES,
    this.FTEDHCRE,
    this.FTEDHMOD,
    this.FTEVALIDE = 0.0,
    this.FTEDATEVAL,
    this.FTEREGLEMENT = 0.0,
    this.FTECPT,
    this.FTERUB,
    this.FTEDESC = '',
    this.FTEDHIMPR,
    this.FTETYPEREM = 0.0,
    this.FTEREF,
    this.FTEJNL = '',
    this.FTECREPAR = '',
    this.FTEMODPAR = '',
    this.FTEVALPAR = '',
    this.FTEIMPRPAR = '',
    this.FTEDHREGL,
    this.FTEREGLPAR = '',
    this.FTECODESEL,
    this.FTEFRAISACC = 0.0,
    this.FTETIMBRE = 0.0,
    this.FTECATEG = '',
    this.FTEVERROU = 0.0,
    this.FTEDERNOUVERPAR = '',
    this.FTEDHDERNOUVER,
    this.FOUNOM = '',
    this.FOUPRENOM = '',
    this.FOUTEL1 = '',
  });

  // Convert a ReceptionEntate object to a map
  Map<String, dynamic> toJson() => {
        'FTEDATE': FTEDATE?.toIso8601String(),
        'FTENO': FTENO,
        'FTECDEDATE': FTECDEDATE?.toIso8601String(),
        'FTECDENO': FTECDENO,
        'FTEFOU': FTEFOU,
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
        'FTEREGLEMENT': FTEREGLEMENT,
        'FTECPT': FTECPT,
        'FTERUB': FTERUB,
        'FTEDESC': FTEDESC,
        'FTEDHIMPR': FTEDHIMPR?.toIso8601String(),
        'FTETYPEREM': FTETYPEREM,
        'FTEREF': FTEREF,
        'FTEJNL': FTEJNL,
        'FTECREPAR': FTECREPAR,
        'FTEMODPAR': FTEMODPAR,
        'FTEVALPAR': FTEVALPAR,
        'FTEIMPRPAR': FTEIMPRPAR,
        'FTEDHREGL': FTEDHREGL?.toIso8601String(),
        'FTEREGLPAR': FTEREGLPAR,
        'FTECODESEL': FTECODESEL,
        'FTEFRAISACC': FTEFRAISACC,
        'FTETIMBRE': FTETIMBRE,
        'FTECATEG': FTECATEG,
        'FTEVERROU': FTEVERROU,
        'FTEDERNOUVERPAR': FTEDERNOUVERPAR,
        'FTEDHDERNOUVER': FTEDHDERNOUVER?.toIso8601String(),
        'FOUNOM': FOUNOM,
        'FOUPRENOM': FOUPRENOM,
        'FOUTEL1': FOUTEL1,
      };

  // Create a ReceptionEntate object from a map
  factory ReceptionEntate.fromJson(Map<String, dynamic> json) => ReceptionEntate(
        FTEDATE: DateTime.parse(json['FTEDATE']),
        FTENO: json['FTENO'] ?? '',
        FTECDEDATE: json['FTECDEDATE'] != null ? DateTime.parse(json['FTECDEDATE']) : null,
        FTECDENO: json['FTECDENO'] ?? '',
        FTEFOU: json['FTEFOU'] ?? '',
        FTETYPE: (json['FTETYPE'] as num?)?.toDouble() ?? 0.0,
        FTEMNTHT: (json['FTEMNTHT'] as num?)?.toDouble() ?? 0.0,
        FTEMNTTVA: (json['FTEMNTTVA'] as num?)?.toDouble() ?? 0.0,
        FTEMNTTTC: (json['FTEMNTTTC'] as num?)?.toDouble() ?? 0.0,
        FTETREM: (json['FTETREM'] as num?)?.toDouble() ?? 0.0,
        FTEREMISE: (json['FTEREMISE'] as num?)?.toDouble() ?? 0.0,
        FTENAP: (json['FTENAP'] as num?)?.toDouble() ?? 0.0,
        FTEREGLE: (json['FTEREGLE'] as num?)?.toDouble() ?? 0.0,
        FTESOLDE: (json['FTESOLDE'] as num?)?.toDouble() ?? 0.0,
        FTENOTES: json['FTENOTES'] ?? '',
        FTEDHCRE: json['FTEDHCRE'] != null ? DateTime.parse(json['FTEDHCRE']) : null,
        FTEDHMOD: json['FTEDHMOD'] != null ? DateTime.parse(json['FTEDHMOD']) : null,
        FTEVALIDE: (json['FTEVALIDE'] as num?)?.toDouble() ?? 0.0,
        FTEDATEVAL: json['FTEDATEVAL'] != null ? DateTime.parse(json['FTEDATEVAL']) : null,
        FTEREGLEMENT: (json['FTEREGLEMENT'] as num?)?.toDouble() ?? 0.0,
        FTECPT: json['FTECPT'] ?? '',
        FTERUB: json['FTERUB'] ?? '',
        FTEDESC: json['FTEDESC'] ?? '',
        FTEDHIMPR: json['FTEDHIMPR'] != null ? DateTime.parse(json['FTEDHIMPR']) : null,
        FTETYPEREM: (json['FTETYPEREM'] as num?)?.toDouble() ?? 0.0,
        FTEREF: json['FTEREF'] ?? '',
        FTEJNL: json['FTEJNL'] ?? '',
        FTECREPAR: json['FTECREPAR'] ?? '',
        FTEMODPAR: json['FTEMODPAR'] ?? '',
        FTEVALPAR: json['FTEVALPAR'] ?? '',
        FTEIMPRPAR: json['FTEIMPRPAR'] ?? '',
        FTEDHREGL: json['FTEDHREGL'] != null ? DateTime.parse(json['FTEDHREGL']) : null,
        FTEREGLPAR: json['FTEREGLPAR'] ?? '',
        FTECODESEL: json['FTECODESEL'],
        FTEFRAISACC: (json['FTEFRAISACC'] as num?)?.toDouble() ?? 0.0,
        FTETIMBRE: (json['FTETIMBRE'] as num?)?.toDouble() ?? 0.0,
        FTECATEG: json['FTECATEG'] ?? '',
        FTEVERROU: (json['FTEVERROU'] as num?)?.toDouble() ?? 0.0,
        FTEDERNOUVERPAR: json['FTEDERNOUVERPAR'] ?? '',
        FTEDHDERNOUVER: json['FTEDHDERNOUVER'] != null ? DateTime.parse(json['FTEDHDERNOUVER']) : null,
        FOUNOM: json['FOUNOM'] ?? '',
        FOUPRENOM: json['FOUPRENOM'] ?? '',
        FOUTEL1: json['FOUTEL1'] ?? '',
      );

  // Convert a list of ReceptionEntate objects to a list of maps
  static List<Map<String, dynamic>> listToJson(List<ReceptionEntate> list) {
    return list.map((item) => item.toJson()).toList();
  }

  // Create a list of ReceptionEntate objects from a list of maps
  static List<ReceptionEntate> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((item) => ReceptionEntate.fromJson(item)).toList();
  }
}
