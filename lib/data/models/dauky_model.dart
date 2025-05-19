import '../../core/core.dart';

class DauKyHangHoaModel {
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
    this.tenHH,
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
      itemID: map[DauKyHangHoaString.itemID],
      soTon: Helper.convertDouble(map[DauKyHangHoaString.soTon]),
      giaVon: Helper.convertDouble(map[DauKyHangHoaString.giaVon]),
      ngay: map[DauKyHangHoaString.ngay] ?? Helper.sqlDateTimeNow(),
      maHH: map[DauKyHangHoaString.maHH] ?? '',
      tenHH: map[DauKyHangHoaString.tenHH] ?? '',
    );
  }
}

abstract class DauKyHangHoaString {
  static const thang = "Thang";
  static const itemID = "ItemID";
  static const soTon = "SoTon";
  static const giaVon = "GiaVon";
  static const ngay = "Ngay";
  static const maHH = "MaHH";
  static const tenHH = "TenHH";
}

class DauKyKhachHangModel {
  final String? thang;
  final String maKhach;
  final String tenKH;
  final double soDuNo;
  final String ngay;

  const DauKyKhachHangModel({
    this.thang,
    required this.maKhach,
    required this.tenKH,
    required this.soDuNo,
    required this.ngay,
  });

  Map<String, dynamic> toMap() {
    return {
      DauKyKhachHangString.thang: thang,
      DauKyKhachHangString.maKhach: maKhach,
      // DauKyKhachHangString.tenKH: tenKH,
      DauKyKhachHangString.soDuNo: soDuNo,
      DauKyKhachHangString.ngay: ngay,
    };
  }

  factory DauKyKhachHangModel.fromMap(Map<String, dynamic> map) {
    return DauKyKhachHangModel(
      // thang: map['thang'] as String,
      maKhach: map[DauKyKhachHangString.maKhach],
      tenKH: map[DauKyKhachHangString.tenKH] ?? '',
      soDuNo: Helper.convertDouble(map[DauKyKhachHangString.soDuNo]),
      ngay: map[DauKyHangHoaString.ngay],
    );
  }
}

abstract class DauKyKhachHangString {
  static const thang = "Thang";
  static const maKhach = "MaKhach";
  static const tenKH = "TenKH";
  static const soDuNo = "SoDuNo";
  static const ngay = "Ngay";
}

class DauKyTaiKhoangModel {
  final String? thang;
  final String maTK;
  final String? tenTK;
  final String? tc;
  final double dkNo;
  final double dkCo;
  bool dKy;

  DauKyTaiKhoangModel({
    this.thang,
    required this.maTK,
    required this.dkNo,
    required this.dkCo,
    this.dKy = true,
    this.tenTK,
    this.tc,
  });

  Map<String, dynamic> toMap() {
    return {
      DauKyTaiKhoanString.thang: thang,
      DauKyTaiKhoanString.maTK: maTK,
      DauKyTaiKhoanString.dkNo: dkNo,
      DauKyTaiKhoanString.dkCo: dkCo,
      DauKyTaiKhoanString.dKy: dKy?1:0,
    };
  }

  factory DauKyTaiKhoangModel.fromMap(Map<String, dynamic> map) {
    return DauKyTaiKhoangModel(
      // thang: map[DauKyTaiKhoanString.thang],
      tenTK: map[DauKyTaiKhoanString.tenTK]??'',
      maTK: map[DauKyTaiKhoanString.maTK]??'',
      dkNo: map[DauKyTaiKhoanString.dkNo]==null?0:double.parse( map[DauKyTaiKhoanString.dkNo].toString()),
      dkCo:  map[DauKyTaiKhoanString.dkCo]==null?0:double.parse( map[DauKyTaiKhoanString.dkCo].toString()),
      // dKy: map[DauKyTaiKhoanString.dKy],
      tc: map[DauKyTaiKhoanString.tc]??'',
    );
  }
}

abstract class DauKyTaiKhoanString {
  static const thang = "Thang";
  static const maTK = "MaTK";
  static const tenTK = "TenTK";
  static const dkNo = "DKNo";
  static const dkCo = "DKCo";
  static const dKy = "DKy";
  static const tc = "TinhChat";
}
