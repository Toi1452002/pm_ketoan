class TTDNModel{
  final int? id;
  final String ma;
  final String tieuDe;
  final String noiDung;

  const TTDNModel({
    this.id,
    required this.ma,
    required this.tieuDe,
    required this.noiDung,
  });


  factory TTDNModel.fromMap(Map<String, dynamic> map) {
    return TTDNModel(
      id: map[TTDNString.id],
      ma: map[TTDNString.ma],
      tieuDe: map[TTDNString.tieuDe]??'',
      noiDung: map[TTDNString.noiDung]??'',
    );
  }
}

abstract class TTDNString{
  static const id = "ID";
  static const ma = "Ma";
  static const tieuDe = "TieuDe";
  static const noiDung = "NoiDung";
  static const soHangDong = "SoHangDong";
}