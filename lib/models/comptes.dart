class Comptes {
  String cptNo;
  String cptNom;
  String cptAbv;
  int cptSelect;
  Comptes({
    required this.cptNo,
    required this.cptNom,
    required this.cptAbv,
    required this.cptSelect,
  });

  factory Comptes.fromJson(Map<String, dynamic> json) {
    return Comptes(
      cptNo: json['CPTNO'] ?? '',
      cptNom: json['CPTNOM'] ?? '',
      cptAbv: json['CPTABV'] ?? '',
      cptSelect: json['CPTSELECT'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CPTNO': cptNo,
      'CPTNOM': cptNom,
      'CPTABV': cptAbv,
      'CPTSELECT': cptSelect,
    };
  }
}
