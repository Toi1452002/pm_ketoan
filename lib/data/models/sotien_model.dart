class SoTienModel {
  final String ngay;
  final String phieu;
  final String noiDung;
  final String kieu;
  final String pttt;
  final String soCT;
  final String tkdu;
  final double thu;
  final double chi;
  final int stt;

  const SoTienModel({
    required this.ngay,
    required this.phieu,
    required this.noiDung,
    required this.kieu,
    required this.pttt,
    required this.soCT,
    required this.tkdu,
    required this.thu,
    required this.chi,
    required this.stt,
  });

  factory SoTienModel.fromMap(Map<String, dynamic> map) {
    return SoTienModel(
      ngay: map[SoTienString.ngay]??'',
      phieu: map[SoTienString.phieu]??'',
      noiDung: map[SoTienString.noiDung]??'',
      kieu: map[SoTienString.kieu]??'',
      pttt: map[SoTienString.pttt]??'',
      soCT: map[SoTienString.soCT]??'',
      tkdu: map[SoTienString.tkDU]??'',
      thu: double.parse(map[SoTienString.thu].toString()),
      chi:  double.parse( map[SoTienString.chi].toString()),
      stt: map['STT'],
    );
  }
}

abstract class SoTienString {
  static const ngay = "Ngay";
  static const phieu = "Phieu";
  static const noiDung = "NoiDung";
  static const kieu = "Kieu";
  static const pttt = "PTTT";
  static const soCT = "SoCT";
  static const tkDU = "TKDU";
  static const thu = "Thu";
  static const chi = "Chi";
}


class SoMBHangModel{
  final String ngay;
  final String phieu;
  final String tenHH;
  final String dvt;
  final double soLg;
  final double donGia;
  final double no;
  final double co;
  final int stt;

  const SoMBHangModel({
    required this.ngay,
    required this.phieu,
    required this.tenHH,
    required this.dvt,
    required this.soLg,
    required this.donGia,
    required this.no,
    required this.co,
    required this.stt
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     SoMuaHang.ngay: ngay,
  //     SoMuaHang.phieu: phieu,
  //     SoMuaHang.tenHH: tenHH,
  //     SoMuaHang.dvt: dvt,
  //     SoMuaHang.soLg: soLg,
  //     SoMuaHang.donGia: donGia,
  //     SoMuaHang.no: no,
  //     SoMuaHang.co: co,
  //     SoMuaHang.stt: stt,
  //   };
  // }

  factory SoMBHangModel.fromMap(Map<String, dynamic> map) {
    return SoMBHangModel(
      ngay: map[SoMBHangString.ngay] ,
      phieu: map[SoMBHangString.phieu] ,
      tenHH: map[SoMBHangString.tenHH] ??'',
      dvt: map[SoMBHangString.dvt] ??'',
      soLg: double.parse(map[SoMBHangString.soLg].toString()) ,
      donGia: double.parse(map[SoMBHangString.donGia].toString()) ,
      no: double.parse(map[SoMBHangString.no].toString()) ,
      co: double.parse(map[SoMBHangString.co].toString()) ,
      stt: map[SoMBHangString.stt],
    );
  }

}

abstract class SoMBHangString{
  static const stt = "STT";
  static const ngay = "Ngay";
  static const phieu = "Phieu";
  static const tenHH = "TenHH";
  static const dvt = "DVT";
  static const soLg = "SoLg";
  static const donGia = "DonGia";
  static const no = "No";
  static const co = "Co";
}