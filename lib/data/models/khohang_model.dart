import 'package:app_ketoan/data/data.dart';

class BangKeHangNXModel{
  String ngay;
  String phieu;
  String maNX;
  String maKhach;
  String maHang;
  String tenHang;
  String dvt;
  double soLg;
  double donGia;
  double thanhTien;
  int stt;

  BangKeHangNXModel({
    required this.ngay,
    required this.phieu,
    required this.maNX,
    required this.maKhach,
    required this.maHang,
    required this.tenHang,
    required this.dvt,
    required this.soLg,
    required this.donGia,
    required this.thanhTien,
    required this.stt
  });


  factory BangKeHangNXModel.fromMap(Map<String, dynamic> map) {
    return BangKeHangNXModel(
      ngay: map[PhieuXuatString.ngay] ,
      phieu: map[PhieuXuatString.phieu] ,
      maNX: map[PhieuXuatString.maNX] ??'',
      maKhach: map[PhieuXuatString.maKhach] ??'',
      maHang: map[HangHoaString.maHH] ??'',
      tenHang: map[PhieuXuatCTString.tenHH] ??'',
      dvt: map[PhieuXuatCTString.dvt] ??'',
      soLg: double.parse(map[PhieuXuatCTString.soLg].toString()) ,
      donGia: double.parse(map[PhieuXuatCTString.donGia].toString()) ,
      thanhTien: double.parse(map[PhieuXuatCTString.thanhTien].toString()) ,
      stt: map['STT']
    );
  }
}