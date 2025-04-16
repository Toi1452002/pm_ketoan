class MaNghiepVuModel{
  final int? id;
  final String maNghiepVu;
  final String? moTa;

  const MaNghiepVuModel({
    this.id,
    required this.maNghiepVu,
    this.moTa,
  });


  factory MaNghiepVuModel.fromMap(Map<String, dynamic> map) {
    return MaNghiepVuModel(
      id: map[MaNghiepVuString.id],
      maNghiepVu: map[MaNghiepVuString.maNV],
      moTa: map[MaNghiepVuString.moTa]??'',
    );
  }
}

abstract class MaNghiepVuString {
  static const id = "ID";
  static const maNV = "MaNV";
  static const moTa = "MoTa";
}