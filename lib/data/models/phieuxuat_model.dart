import 'hanghoa_model.dart';

class PhieuXuatModel{
  int? id;
  String ngay;
  String phieu;
  String maNX;
  String dienGiai;
  double  congTien;
  double thueSuat;
  double tienThue;
  bool khoa;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  String kyHieu;
  String? soHD;
  String ngayCT;
  String? tkNo;
  String? tkCo;
  String? tkVatNo;
  String? tkVatCo;
  bool kChiuThue;
  String pttt;
  int? stt;
  String? countRow;
  String? maKhach;

  PhieuXuatModel({
    this.id,
    required this.ngay,
    required this.phieu,
    required this.maNX,
    required this.dienGiai,
    required this.congTien,
    required this.thueSuat,
    required this.tienThue,
    required this.khoa,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    required this.kyHieu,
    required this.soHD,
    this.tkNo,
    this.tkCo,
    this.tkVatNo,
    this.tkVatCo,
    required this.kChiuThue,
    required this.pttt,
    required this.ngayCT,
    this.stt,
    this.countRow,
    this.maKhach
  });

  Map<String, dynamic> toMap() {
    return {
      PhieuXuatString.id: id,
      PhieuXuatString.ngay: ngay,
      PhieuXuatString.phieu: phieu,
      PhieuXuatString.maNX: maNX,
      PhieuXuatString.dienGiai: dienGiai,
      PhieuXuatString.congTien: congTien,
      PhieuXuatString.thueSuat: thueSuat,
      PhieuXuatString.tienThue: tienThue,
      PhieuXuatString.khoa: khoa?1:0,
      PhieuXuatString.createdAt: createdAt,
      PhieuXuatString.createdBy: createdBy,
      PhieuXuatString.updatedAt: updatedAt,
      PhieuXuatString.updatedBy: updatedBy,
      PhieuXuatString.kyHieu: kyHieu,
      PhieuXuatString.soHD: soHD,
      PhieuXuatString.ngayCT: ngayCT,
      PhieuXuatString.tkNo: tkNo,
      PhieuXuatString.tkCo: tkCo,
      PhieuXuatString.tkVatNo: tkVatNo,
      PhieuXuatString.tkVatCo: tkVatCo,
      PhieuXuatString.kChiuThue: kChiuThue?1:0,
      PhieuXuatString.pttt: pttt,
    };
  }

  factory PhieuXuatModel.fromMap(Map<String, dynamic> map) {
    return PhieuXuatModel(
      id: map[PhieuXuatString.id] ,
      ngay: map[PhieuXuatString.ngay] ,
      phieu: map[PhieuXuatString.phieu] ,
      maNX: map[PhieuXuatString.maNX] ,
      dienGiai: map[PhieuXuatString.dienGiai] ,
      congTien: double.parse(map[PhieuXuatString.congTien].toString()) ,
      thueSuat: double.parse(map[PhieuXuatString.thueSuat].toString()) ,
      tienThue: double.parse(map[PhieuXuatString.tienThue].toString()) ,
      khoa: map[PhieuXuatString.khoa]==1?true:false ,
      createdAt: map[PhieuXuatString.createdAt] ,
      createdBy: map[PhieuXuatString.createdBy] ,
      updatedAt: map[PhieuXuatString.updatedAt] ,
      updatedBy: map[PhieuXuatString.updatedBy] ,
      kyHieu: map[PhieuXuatString.kyHieu],
      soHD: map[PhieuXuatString.soHD] ,
      ngayCT: map[PhieuXuatString.ngayCT] ,
      tkNo: map[PhieuXuatString.tkNo] ,
      tkCo: map[PhieuXuatString.tkCo] ,
      tkVatNo: map[PhieuXuatString.tkVatNo] ,
      tkVatCo: map[PhieuXuatString.tkVatCo] ,
      kChiuThue: map[PhieuXuatString.kChiuThue] ==1?true:false,
      pttt: map[PhieuXuatString.pttt] ,
      stt: map['STT']??0,
      maKhach: map[PhieuXuatString.maKhach]
    );
  }

  PhieuXuatModel copyWith({
    int? id,
    String? ngay,
    String? phieu,
    String? maNX,
    String? dienGiai,
    double? congTien,
    double? thueSuat,
    double? tienThue,
    bool? khoa,
    String? createdAt,
    String? createdBy,
    String? updatedAt,
    String? updatedBy,
    String? kyHieu,
    String? soCT,
    String? ngayCT,
    String? tkNo,
    String? tkCo,
    String? tkVatNo,
    String? tkVatCo,
    bool? kChiuThue,
    String? pttt,
    int? stt,
    String? countRow,
    String? maKhach
  }) {
    return PhieuXuatModel(
      id: id ?? this.id,
      ngay: ngay ?? this.ngay,
      phieu: phieu ?? this.phieu,
      maNX: maNX ?? this.maNX,
      dienGiai: dienGiai ?? this.dienGiai,
      congTien: congTien ?? this.congTien,
      thueSuat: thueSuat ?? this.thueSuat,
      tienThue: tienThue ?? this.tienThue,
      khoa: khoa ?? this.khoa,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      kyHieu: kyHieu ?? this.kyHieu,
      soHD: soCT ?? this.soHD,
      ngayCT: ngayCT ?? this.ngayCT,
      tkNo: tkNo ?? this.tkNo,
      tkCo: tkCo ?? this.tkCo,
      tkVatNo: tkVatNo ?? this.tkVatNo,
      tkVatCo: tkVatCo ?? this.tkVatCo,
      kChiuThue: kChiuThue ?? this.kChiuThue,
      pttt: pttt ?? this.pttt,
      stt:  stt  ?? this.stt,
      countRow:  countRow?? this.countRow,
      maKhach: maKhach?? this.maKhach
    );
  }
}

abstract class PhieuXuatString{
  static const id = "ID";
  static const ngay = "Ngay";
  static const phieu = "Phieu";
  static const maKhach = "MaKhach";
  static const maNX = "MaNX";
  static const dienGiai = "DienGiai";
  static const congTien = "CongTien";
  static const thueSuat = "ThueSuat";
  static const tienThue = "TienThue";
  static const khoa = "Khoa";
  static const createdAt = "CreatedAt";
  static const createdBy = "CreatedBy";
  static const updatedAt = "UpdatedAt";
  static const updatedBy = "UpdatedBy";
  static const kyHieu = "KyHieu";
  static const soHD = "SoHD";
  static const ngayCT = "NgayCT";
  static const tkNo = "TKNo";
  static const tkCo = "TKCo";
  static const tkVatNo = "TKVatNo";
  static const tkVatCo = "TKVatCo";
  static const kChiuThue = "KChiuThue";
  static const pttt = "PTTT";
}

class PhieuXuatCTModel{
  int? id;
  int? maID;
  int? itemID;
  String? tenHH;
  String? dvt;
  String? maKho;
  double? soLg;
  double? giaVon;
  double? donGia;
  double? thanhTien;
  String? tkGV;
  String? tkKho;
  String? maHH;

  PhieuXuatCTModel({
    this.id,
    this.maID,
    this.itemID,
    this.tenHH,
    this.dvt,
    this.maKho,
    this.soLg,
    this.giaVon,
    this.donGia,
    this.thanhTien,
    this.tkGV,
    this.tkKho,this.maHH
  });

  Map<String, dynamic> toMap() {
    return {
      PhieuXuatCTString.id: id,
      PhieuXuatCTString.maID: maID,
      PhieuXuatCTString.itemID: itemID,
      PhieuXuatCTString.tenHH: tenHH,
      PhieuXuatCTString.dvt: dvt,
      PhieuXuatCTString.maKho: maKho,
      PhieuXuatCTString.soLg: soLg,
      PhieuXuatCTString.giaVon: giaVon,
      PhieuXuatCTString.donGia: donGia,
      PhieuXuatCTString.thanhTien: thanhTien,
      PhieuXuatCTString.tkGV: tkGV,
      PhieuXuatCTString.tkKho: tkKho,
    };
  }

  factory PhieuXuatCTModel.fromMap(Map<String, dynamic> map) {
    return PhieuXuatCTModel(
      id: map[PhieuXuatCTString.id] ,
      maID: map[PhieuXuatCTString.maID] ,
      itemID: map[PhieuXuatCTString.itemID] ,
      tenHH: map[PhieuXuatCTString.tenHH] ??'',
      dvt: map[PhieuXuatCTString.dvt] ??'',
      maKho: map[PhieuXuatCTString.maKho] ,
      soLg: double.parse(map[PhieuXuatCTString.soLg].toString()) ,
      giaVon: double.parse(map[PhieuXuatCTString.giaVon].toString()) ,
      donGia: double.parse(map[PhieuXuatCTString.donGia].toString()) ,
      thanhTien: double.parse(map[PhieuXuatCTString.thanhTien].toString()) ,
      tkGV: map[PhieuXuatCTString.tkGV] ,
      tkKho: map[PhieuXuatCTString.tkKho] ,
      maHH: map['MaHH']??''
    );
  }

  PhieuXuatCTModel copyWith({
    int? id,
    int? maID,
    int? itemID,
    String? tenHH,
    String? dvt,
    String? maKho,
    double? soLg,
    double? giaVon,
    double? donGia,
    double? thanhTien,
    String? tkGV,
    String? tkKho,
  }) {
    return PhieuXuatCTModel(
      id: id ?? this.id,
      maID: maID ?? this.maID,
      itemID: itemID ?? this.itemID,
      tenHH: tenHH ?? this.tenHH,
      dvt: dvt ?? this.dvt,
      maKho: maKho ?? this.maKho,
      soLg: soLg ?? this.soLg,
      giaVon: giaVon ?? this.giaVon,
      donGia: donGia ?? this.donGia,
      thanhTien: thanhTien ?? this.thanhTien,
      tkGV: tkGV ?? this.tkGV,
      tkKho: tkKho ?? this.tkKho,
    );
  }

}

abstract class PhieuXuatCTString{
  static const id = "ID";
  static const maID = "MaID";
  static const itemID = "ItemID";
  static const tenHH = "TenHH";
  static const dvt = "DVT";
  static const maKho = "MaKho";
  static const soLg = "SoLg";
  static const giaVon = "GiaVon";
  static const donGia = "DonGia";
  static const thanhTien = "ThanhTien";
  static const tkGV = "TKgv";
  static const tkKho = "TKkho";
}

class VBCPhieuXuatModel{
  int stt;
  String kyHieu;
  String soHD;
  String ngayCT;
  String tenKH;
  String mst;
  double congTien;
  double tienThue;
  String dienGiai;

  VBCPhieuXuatModel({
    required this.stt,
    required this.kyHieu,
    required this.soHD,
    required this.ngayCT,
    required this.tenKH,
    required this.mst,
    required this.congTien,
    required this.tienThue,
    required this.dienGiai,
  });


  factory VBCPhieuXuatModel.fromMap(Map<String, dynamic> map) {
    return VBCPhieuXuatModel(
      stt: map['STT'] ,
      kyHieu: map[PhieuXuatString.kyHieu] ??'',
      soHD: map[PhieuXuatString.soHD] ??'',
      ngayCT: map[PhieuXuatString.ngayCT] ??'',
      tenKH: map['TenKH'] ??'',
      mst: map['MST'] ??'',
      congTien: double.parse(map[PhieuXuatString.congTien].toString())  ,
      tienThue: double.parse(map[PhieuXuatString.tienThue].toString())  ,
      dienGiai: map[PhieuXuatString.dienGiai] ??'',
    );
  }

}

class VNXBangKeHangBanModel{
  final String maHH;
  final String tenHH;
  final String dvt;
  final double soLg;
  final double tienChuaVat;
  final double thue;
  final double tienThue;
  final double congTien;

  const VNXBangKeHangBanModel({
    required this.maHH,
    required this.tenHH,
    required this.dvt,
    required this.soLg,
    required this.tienChuaVat,
    required this.thue,
    required this.tienThue,
    required this.congTien,
  });


  factory VNXBangKeHangBanModel.fromMap(Map<String, dynamic> map) {
    return VNXBangKeHangBanModel(
      maHH: map[HangHoaString.maHH] ,
      tenHH: map[HangHoaString.tenHH] ,
      dvt: map[PhieuXuatCTString.dvt],
      soLg:double.parse( map[PhieuXuatCTString.soLg].toString()) ,
      tienChuaVat: double.parse(map[PhieuXuatCTString.thanhTien].toString()),
      thue: double.parse(map[PhieuXuatString.thueSuat].toString()) ,
      tienThue: double.parse(map[PhieuXuatString.tienThue].toString()) ,
      congTien: double.parse(map[PhieuXuatString.congTien].toString()),
    );
  }

}