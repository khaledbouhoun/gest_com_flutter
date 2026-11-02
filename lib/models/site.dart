class SiteModel {
  String? cLSNO;
  String? cLSNOM;

  SiteModel({
    this.cLSNO,
    this.cLSNOM,
  });

  SiteModel.fromJson(Map<String, dynamic> json) {
    cLSNO = json['CLSNO'];
    cLSNOM = json['CLSNOM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CLSNO'] = cLSNO;
    data['CLSNOM'] = cLSNOM;

    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SiteModel &&
          runtimeType == other.runtimeType &&
          cLSNO == other.cLSNO;

  @override
  int get hashCode => cLSNO.hashCode;
}
