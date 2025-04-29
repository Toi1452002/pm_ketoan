import '../../core/core.dart';

class DauKyHangHoaModel{
  final String? thang;
  final int? itemID;
  final double soTon;
  final double giaVon;
  final String ngay;
  final String? maHH;
  final String? tenHH;

  const DauKyHangHoaModel({
    this.thang,
    this.itemID,
    required this.soTon,
    required this.giaVon,
    required this.ngay,
    this.maHH,
    this.tenHH
  });

  Map<String, dynamic> toMap() {
    return {
      DauKyHangHoaString.thang: thang,
      DauKyHangHoaString.itemID: itemID,
      DauKyHangHoaString.soTon: soTon,
      DauKyHangHoaString.giaVon: giaVon,
      DauKyHangHoaString.ngay: ngay,
    };
  }

  factory DauKyHangHoaModel.fromMap(Map<String, dynamic> map) {
    return DauKyHangHoaModel(
      // thang: map[DauKyHangHoaString.thang] ,
      itemID: map[DauKyHangHoaString.itemID] ,
      soTon: Helper.convertDouble(map[DauKyHangHoaString.soTon]) ,
      giaVon:Helper.convertDouble(map[DauKyHangHoaString.giaVon]),
      ngay: map[DauKyHangHoaString.ngay] ?? Helper.sqlDateTimeNow(),
      maHH: map[DauKyHangHoaString.maHH]??'',
      tenHH: map[DauKyHangHoaString.tenHH]??''

    );
  }

}

abstract class DauKyHangHoaString{
  static const thang = "Thang";
  static const itemID = "ItemID";
  static const soTon = "SoTon";
  static const giaVon = "GiaVon";
  static const ngay = "Ngay";
  static const maHH = "MaHH";
  static const tenHH = "TenHH";
}
