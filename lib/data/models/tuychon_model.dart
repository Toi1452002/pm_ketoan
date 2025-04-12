class TuyChonModel{
  String nhom;
  int giaTri;
  String? moTa;

  TuyChonModel({
    required this.nhom,
    required this.giaTri,
    this.moTa,
  });

  Map<String, dynamic> toMap() {
    return {
      TuyChonString.nhom: nhom,
      TuyChonString.giaTri: giaTri,
      TuyChonString.moTa: moTa,
    };
  }

  factory TuyChonModel.fromMap(Map<String, dynamic> map) {
    return TuyChonModel(
      nhom: map[TuyChonString.nhom],
      giaTri: map[TuyChonString.giaTri],
      moTa: map[TuyChonString.moTa] ??'',
    );
  }

  TuyChonModel copyWith({
    String? nhom,
    int? giaTri,
    String? moTa,
  }) {
    return TuyChonModel(
      nhom: nhom ?? this.nhom,
      giaTri: giaTri ?? this.giaTri,
      moTa: moTa ?? this.moTa,
    );
  }

}

abstract class TuyChonString{
  static const nhom = "Nhom";
  static const giaTri = "GiaTri";
  static const moTa = "MoTa";
}