class Fournisseur {
  final String FOUNO;
  final String FOUCATEG;
  final double FOUAM;
  final String FOUNATURE;
  final String FOUPRENOM;
  final DateTime? FOUDATENSC;
  final double FOUSEXE;
  final String FOUNAT;
  final String FOUADR1;
  final String FOUADR2;
  final String FOUADR3;
  final String FOUADR4;
  final String FOUPAYS;
  final String FOUTERR;
  final String FOUTEL1;
  final String FOUTEL2;
  final String FOUTEL3;
  final String FOUFAX;
  final String FOUEMAIL;
  final String FOUWEB;
  final String FOUBANQUE;
  final String FOUAGENCE;
  final String FOUIF;
  final String FOUAI;
  final String FOUNIS;
  final double FOUREMISE;
  final double FOUSOLDE;
  final double FOUSLDINIT;
  final double FOUREGL;
  final double FOUSOLDEAB;
  final double FOUSLDINITAB;
  final double FOUREGLAB;
  final List<double>? FOUNOTES;
  final double FOUACTIF;
  final double FOUCACHE;
  final String FOUNOBOITE;
  final String FOUAGENT;
  final String FOUREGION;
  final String FOUNOM;
  final double FOUNEW;
  final String FOURC;
  final String FOUCOMPTE;
  final String FOUBANQUE2;
  final String FOUAGENCE2;
  final String FOUCOMPTE2;
  final String FOUBANQUE3;
  final String FOUAGENCE3;
  final String FOUCOMPTE3;
  final double FOULOCETR;
  final DateTime? FOUDHCRE;
  final String FOUCREPAR;
  final DateTime? FOUDHMOD;
  final String FOUMODPAR;

  Fournisseur({
    required this.FOUNO,
    required this.FOUCATEG,
    this.FOUAM = 0,
    this.FOUNATURE = '',
    this.FOUPRENOM = '',
    this.FOUDATENSC,
    this.FOUSEXE = 0,
    this.FOUNAT = '',
    this.FOUADR1 = '',
    this.FOUADR2 = '',
    this.FOUADR3 = '',
    this.FOUADR4 = '',
    this.FOUPAYS = '',
    this.FOUTERR = '',
    this.FOUTEL1 = '',
    this.FOUTEL2 = '',
    this.FOUTEL3 = '',
    this.FOUFAX = '',
    this.FOUEMAIL = '',
    this.FOUWEB = '',
    this.FOUBANQUE = '',
    this.FOUAGENCE = '',
    this.FOUIF = '',
    this.FOUAI = '',
    this.FOUNIS = '',
    this.FOUREMISE = 0,
    this.FOUSOLDE = 0,
    this.FOUSLDINIT = 0,
    this.FOUREGL = 0,
    this.FOUSOLDEAB = 0,
    this.FOUSLDINITAB = 0,
    this.FOUREGLAB = 0,
    this.FOUNOTES,
    this.FOUACTIF = 0,
    this.FOUCACHE = 0,
    this.FOUNOBOITE = '',
    this.FOUAGENT = '',
    this.FOUREGION = '',
    this.FOUNOM = '',
    this.FOUNEW = 0,
    this.FOURC = '',
    this.FOUCOMPTE = '',
    this.FOUBANQUE2 = '',
    this.FOUAGENCE2 = '',
    this.FOUCOMPTE2 = '',
    this.FOUBANQUE3 = '',
    this.FOUAGENCE3 = '',
    this.FOUCOMPTE3 = '',
    this.FOULOCETR = 0,
    this.FOUDHCRE,
    this.FOUCREPAR = '',
    this.FOUDHMOD,
    this.FOUMODPAR = '',
  });

  factory Fournisseur.fromJson(Map<String, dynamic> json) {
    return Fournisseur(
      FOUNO: json['FOUNO'] ?? '',
      FOUCATEG: json['FOUCATEG'] ?? '',
      FOUAM: json['FOUAM']?.toDouble() ?? 0,
      FOUNATURE: json['FOUNATURE'] ?? '',
      FOUPRENOM: json['FOUPRENOM'] ?? '',
      FOUDATENSC: json['FOUDATENSC'] != null ? DateTime.parse(json['FOUDATENSC']) : null,
      FOUSEXE: json['FOUSEXE']?.toDouble() ?? 0,
      FOUNAT: json['FOUNAT'] ?? '',
      FOUADR1: json['FOUADR1'] ?? '',
      FOUADR2: json['FOUADR2'] ?? '',
      FOUADR3: json['FOUADR3'] ?? '',
      FOUADR4: json['FOUADR4'] ?? '',
      FOUPAYS: json['FOUPAYS'] ?? '',
      FOUTERR: json['FOUTERR'] ?? '',
      FOUTEL1: json['FOUTEL1'] ?? '',
      FOUTEL2: json['FOUTEL2'] ?? '',
      FOUTEL3: json['FOUTEL3'] ?? '',
      FOUFAX: json['FOUFAX'] ?? '',
      FOUEMAIL: json['FOUEMAIL'] ?? '',
      FOUWEB: json['FOUWEB'] ?? '',
      FOUBANQUE: json['FOUBANQUE'] ?? '',
      FOUAGENCE: json['FOUAGENCE'] ?? '',
      FOUIF: json['FOUIF'] ?? '',
      FOUAI: json['FOUAI'] ?? '',
      FOUNIS: json['FOUNIS'] ?? '',
      FOUREMISE: json['FOUREMISE']?.toDouble() ?? 0,
      FOUSOLDE: json['FOUSOLDE']?.toDouble() ?? 0,
      FOUSLDINIT: json['FOUSLDINIT']?.toDouble() ?? 0,
      FOUREGL: json['FOUREGL']?.toDouble() ?? 0,
      FOUSOLDEAB: json['FOUSOLDEAB']?.toDouble() ?? 0,
      FOUSLDINITAB: json['FOUSLDINITAB']?.toDouble() ?? 0,
      FOUREGLAB: json['FOUREGLAB']?.toDouble() ?? 0,
      FOUNOTES: json['FOUNOTES'] != null ? List<double>.from(json['FOUNOTES'].map((x) => x.toDouble())) : null,
      FOUACTIF: json['FOUACTIF']?.toDouble() ?? 0,
      FOUCACHE: json['FOUCACHE']?.toDouble() ?? 0,
      FOUNOBOITE: json['FOUNOBOITE'] ?? '',
      FOUAGENT: json['FOUAGENT'] ?? '',
      FOUREGION: json['FOUREGION'] ?? '',
      FOUNOM: json['FOUNOM'] ?? '',
      FOUNEW: json['FOUNEW']?.toDouble() ?? 0,
      FOURC: json['FOURC'] ?? '',
      FOUCOMPTE: json['FOUCOMPTE'] ?? '',
      FOUBANQUE2: json['FOUBANQUE2'] ?? '',
      FOUAGENCE2: json['FOUAGENCE2'] ?? '',
      FOUCOMPTE2: json['FOUCOMPTE2'] ?? '',
      FOUBANQUE3: json['FOUBANQUE3'] ?? '',
      FOUAGENCE3: json['FOUAGENCE3'] ?? '',
      FOUCOMPTE3: json['FOUCOMPTE3'] ?? '',
      FOULOCETR: json['FOULOCETR']?.toDouble() ?? 0,
      FOUDHCRE: json['FOUDHCRE'] != null ? DateTime.parse(json['FOUDHCRE']) : null,
      FOUCREPAR: json['FOUCREPAR'] ?? '',
      FOUDHMOD: json['FOUDHMOD'] != null ? DateTime.parse(json['FOUDHMOD']) : null,
      FOUMODPAR: json['FOUMODPAR'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FOUNO': FOUNO,
      'FOUCATEG': FOUCATEG,
      'FOUAM': FOUAM,
      'FOUNATURE': FOUNATURE,
      'FOUPRENOM': FOUPRENOM,
      'FOUDATENSC': FOUDATENSC?.toIso8601String(),
      'FOUSEXE': FOUSEXE,
      'FOUNAT': FOUNAT,
      'FOUADR1': FOUADR1,
      'FOUADR2': FOUADR2,
      'FOUADR3': FOUADR3,
      'FOUADR4': FOUADR4,
      'FOUPAYS': FOUPAYS,
      'FOUTERR': FOUTERR,
      'FOUTEL1': FOUTEL1,
      'FOUTEL2': FOUTEL2,
      'FOUTEL3': FOUTEL3,
      'FOUFAX': FOUFAX,
      'FOUEMAIL': FOUEMAIL,
      'FOUWEB': FOUWEB,
      'FOUBANQUE': FOUBANQUE,
      'FOUAGENCE': FOUAGENCE,
      'FOUIF': FOUIF,
      'FOUAI': FOUAI,
      'FOUNIS': FOUNIS,
      'FOUREMISE': FOUREMISE,
      'FOUSOLDE': FOUSOLDE,
      'FOUSLDINIT': FOUSLDINIT,
      'FOUREGL': FOUREGL,
      'FOUSOLDEAB': FOUSOLDEAB,
      'FOUSLDINITAB': FOUSLDINITAB,
      'FOUREGLAB': FOUREGLAB,
      'FOUNOTES': FOUNOTES,
      'FOUACTIF': FOUACTIF,
      'FOUCACHE': FOUCACHE,
      'FOUNOBOITE': FOUNOBOITE,
      'FOUAGENT': FOUAGENT,
      'FOUREGION': FOUREGION,
      'FOUNOM': FOUNOM,
      'FOUNEW': FOUNEW,
      'FOURC': FOURC,
      'FOUCOMPTE': FOUCOMPTE,
      'FOUBANQUE2': FOUBANQUE2,
      'FOUAGENCE2': FOUAGENCE2,
      'FOUCOMPTE2': FOUCOMPTE2,
      'FOUBANQUE3': FOUBANQUE3,
      'FOUAGENCE3': FOUAGENCE3,
      'FOUCOMPTE3': FOUCOMPTE3,
      'FOULOCETR': FOULOCETR,
      'FOUDHCRE': FOUDHCRE?.toIso8601String(),
      'FOUCREPAR': FOUCREPAR,
      'FOUDHMOD': FOUDHMOD?.toIso8601String(),
      'FOUMODPAR': FOUMODPAR,
    };
  }

  static List<Fournisseur> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Fournisseur.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Fournisseur> list) {
    return list.map((item) => item.toJson()).toList();
  }
}
