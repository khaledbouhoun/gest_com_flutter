class JournalModel {
  String? jouNo;
  String? jouNom;

  JournalModel({this.jouNo, this.jouNom});

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      jouNo: json['JouNo'] ?? '',
      jouNom: json['JouNom'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'JouNo': jouNo,
      'JouNom': jouNom,
    };
  }

  static List<JournalModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => JournalModel.fromJson(json)).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalModel &&
          runtimeType == other.runtimeType &&
          jouNo == other.jouNo;

  @override
  int get hashCode => jouNo.hashCode;
}
