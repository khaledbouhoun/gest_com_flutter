class User {
  String USRNOM;
  String USRPRENOM;
  String USRLOGIN;
  String USRPASSW;
  String USRDOS;
  int USRTYPE;
  double USRETAT;
  String? USRCON;
  String? USRCONLEA;
  String? USRDECONLEA;
  String USRNO;
  double USRCACHE;
  double USRSHORTIN;
  double USRSHORTOUT;

  User({
    required this.USRNOM,
    required this.USRPRENOM,
    required this.USRLOGIN,
    required this.USRPASSW,
    required this.USRDOS,
    required this.USRTYPE,
    required this.USRETAT,
    this.USRCON,
    this.USRCONLEA,
    this.USRDECONLEA,
    required this.USRNO,
    required this.USRCACHE,
    required this.USRSHORTIN,
    required this.USRSHORTOUT,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      USRNOM: json['USRNOM'] ?? '',
      USRPRENOM: json['USRPRENOM'] ?? '',
      USRLOGIN: json['USRLOGIN'] ?? '',
      USRPASSW: json['USRPASSW'] ?? '',
      USRDOS: json['USRDOS'] ?? '',
      USRTYPE: (json['USRTYPE'] as num?)?.toInt() ?? 0,
      USRETAT: (json['USRETAT'] as num?)?.toDouble() ?? 0.0,
      USRCON: json['USRCON'] ?? '',
      USRCONLEA: json['USRCONLEA'] ?? '',
      USRDECONLEA: json['USRDECONLEA'] ?? '',
      USRNO: json['USRNO'] ?? '',
      USRCACHE: (json['USRCACHE'] as num?)?.toDouble() ?? 0.0,
      USRSHORTIN: (json['USRSHORTIN'] as num?)?.toDouble() ?? 0.0,
      USRSHORTOUT: (json['USRSHORTOUT'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'USRNOM': USRNOM,
      'USRPRENOM': USRPRENOM,
      'USRLOGIN': USRLOGIN,
      'USRPASSW': USRPASSW,
      'USRDOS': USRDOS,
      'USRTYPE': USRTYPE,
      'USRETAT': USRETAT,
      'USRCON': USRCON,
      'USRCONLEA': USRCONLEA,
      'USRDECONLEA': USRDECONLEA,
      'USRNO': USRNO,
      'USRCACHE': USRCACHE,
      'USRSHORTIN': USRSHORTIN,
      'USRSHORTOUT': USRSHORTOUT,
    };
  }

  static List<User> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => User.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<User> userList) {
    return userList.map((user) => user.toJson()).toList();
  }
}
