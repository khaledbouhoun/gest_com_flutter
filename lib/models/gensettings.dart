class GenSettings {
  int? prmCursLinCol;
  int? prmCalcConsom;
  String? prmCheminINI;
  String? prmCheminPCC;
  int? prmBDTournee;

  GenSettings({this.prmCursLinCol, this.prmCalcConsom, this.prmCheminINI, this.prmCheminPCC, this.prmBDTournee});

  GenSettings.fromJson(Map<String, dynamic> json) {
    prmCursLinCol = json['PrmCursLinCol'];
    prmCalcConsom = json['PrmCalcConsom'];
    prmCheminINI = json['PrmCheminINI'];
    prmCheminPCC = json['PrmCheminPCC'];
    prmBDTournee = json['PrmBDTournee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PrmCursLinCol'] = prmCursLinCol;
    data['PrmCalcConsom'] = prmCalcConsom;
    data['PrmCheminINI'] = prmCheminINI;
    data['PrmCheminPCC'] = prmCheminPCC;
    data['PrmBDTournee'] = prmBDTournee;
    return data;
  }
}
