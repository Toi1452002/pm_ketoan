import 'hanghoa_model.dart';

class PhieuNhapModel{
  int? id;
  String ngay;
  String phieu;
  String? maKhach;
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
  String? soCT;
  String ngayCT;
  String? tkNo;
  String? tkCo;
  String? tkVatNo;
  String? tkVatCo;
  bool kChiuThue;
  String pttt;
  int? stt;
  String? countRow;

  PhieuNhapModel({
    this.id,
    required this.ngay,
    required this.phieu,
    this.maKhach,
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
    required this.ngayCT,
    this.tkNo,
    this.tkCo,
    this.tkVatNo,
    this.tkVatCo,
    required this.soCT,
    required this.kChiuThue,
    required this.pttt,
    this.stt,
    this.countRow,
  });

  Map<String, dynamic> toMap() {
    return {
      PhieuNhapString.id: id,
      PhieuNhapString.ngay: ngay,
      PhieuNhapString.phieu: phieu,
      PhieuNhapString.maNX: maNX,
      PhieuNhapString.dienGiai: dienGiai,
      PhieuNhapString.congTien: congTien,
      PhieuNhapString.thueSuat: thueSuat,
      PhieuNhapString.tienThue: tienThue,
      PhieuNhapString.khoa: khoa?1:0,
      PhieuNhapString.createdAt: createdAt,
      PhieuNhapString.createdBy: createdBy,
      PhieuNhapString.updatedAt: updatedAt,
      PhieuNhapString.updatedBy: updatedBy,
      PhieuNhapString.kyHieu: kyHieu,
      PhieuNhapString.soCT: soCT,
      PhieuNhapString.ngayCT: ngayCT,
      PhieuNhapString.tkNo: tkNo,
      PhieuNhapString.tkCo: tkCo,
      PhieuNhapString.tkVatNo: tkVatNo,
      PhieuNhapString.tkVatCo: tkVatCo,
      PhieuNhapString.kChiuThue: kChiuThue?1:0,
      PhieuNhapString.pttt: pttt,
    };
  }

  factory PhieuNhapModel.fromMap(Map<String, dynamic> map) {
    return PhieuNhapModel(
        id: map[PhieuNhapString.id] ,
        ngay: map[PhieuNhapString.ngay] ,
        phieu: map[PhieuNhapString.phieu] ,
        maNX: map[PhieuNhapString.maNX] ,
        dienGiai: map[PhieuNhapString.dienGiai] ,
        congTien: double.parse(map[PhieuNhapString.congTien].toString()) ,
        thueSuat: double.parse(map[PhieuNhapString.thueSuat].toString()) ,
        tienThue: double.parse(map[PhieuNhapString.tienThue].toString()) ,
        khoa: map[PhieuNhapString.khoa]==1?true:false ,
        createdAt: map[PhieuNhapString.createdAt] ,
        createdBy: map[PhieuNhapString.createdBy] ,
        updatedAt: map[PhieuNhapString.updatedAt] ,
        updatedBy: map[PhieuNhapString.updatedBy] ,
        kyHieu: map[PhieuNhapString.kyHieu],
        soCT: map[PhieuNhapString.soCT] ,
        ngayCT: map[PhieuNhapString.ngayCT] ,
        tkNo: map[PhieuNhapString.tkNo] ,
        tkCo: map[PhieuNhapString.tkCo] ,
        tkVatNo: map[PhieuNhapString.tkVatNo] ,
        tkVatCo: map[PhieuNhapString.tkVatCo] ,
        kChiuThue: map[PhieuNhapString.kChiuThue] ==1?true:false,
        pttt: map[PhieuNhapString.pttt] ,
        stt: map['STT']??0,
        maKhach: map[PhieuNhapString.maKhach]
    );
  }

  PhieuNhapModel copyWith({
    int? id,
    String? ngay,
    String? phieu,
    String? maKhach,
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
  }) {
    return PhieuNhapModel(
      id: id ?? this.id,
      ngay: ngay ?? this.ngay,
      phieu: phieu ?? this.phieu,
      maKhach: maKhach ?? this.maKhach,
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
      soCT: soCT ?? this.soCT,
      ngayCT: ngayCT ?? this.ngayCT,
      tkNo: tkNo ?? this.tkNo,
      tkCo: tkCo ?? this.tkCo,
      tkVatNo: tkVatNo ?? this.tkVatNo,
      tkVatCo: tkVatCo ?? this.tkVatCo,
      kChiuThue: kChiuThue ?? this.kChiuThue,
      pttt: pttt ?? this.pttt,
      stt: stt ?? this.stt,
      countRow: countRow ?? this.countRow,
    );
  }

}
abstract class PhieuNhapString{
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
  static const soCT = "SoCT";
  static const ngayCT = "NgayCT";
  static const tkNo = "TKNo";
  static const tkCo = "TKCo";
  static const tkVatNo = "TKVatNo";
  static const tkVatCo = "TKVatCo";
  static const kChiuThue = "KChiuThue";
  static const pttt = "PTTT";
}

class PhieuNhapCTModel{
  int? id;
  int? maID;
  int? itemID;
  String? tenHH;
  String? dvt;
  String? maKho;
  double? soLg;
  double? donGia;
  double? thanhTien;
  // String? tkGV;
  String? tkKho;
  String? maHH;

  PhieuNhapCTModel({
    this.id,
    this.maID,
    this.itemID,
    this.tenHH,
    this.dvt,
    this.maKho,
    this.soLg,
    this.donGia,
    this.thanhTien,
    this.tkKho,
    this.maHH,
  });

  
  
  PhieuNhapCTModel copyWith({
    int? id,
    int? maID,
    int? itemID,
    String? tenHH,
    String? dvt,
    String? maKho,
    double? soLg,
    double? donGia,
    double? thanhTien,
    String? tkKho,
    String? maHH,
  }) {
    return PhieuNhapCTModel(
      id: id ?? this.id,
      maID: maID ?? this.maID,
      itemID: itemID ?? this.itemID,
      tenHH: tenHH ?? this.tenHH,
      dvt: dvt ?? this.dvt,
      maKho: maKho ?? this.maKho,
      soLg: soLg ?? this.soLg,
      donGia: donGia ?? this.donGia,
      thanhTien: thanhTien ?? this.thanhTien,
      tkKho: tkKho ?? this.tkKho,
      maHH: maHH ?? this.maHH,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      PhieuNhapCTString.id: id,
      PhieuNhapCTString.maID: maID,
      PhieuNhapCTString.itemID: itemID,
      PhieuNhapCTString.tenHH: tenHH,
      PhieuNhapCTString.dvt: dvt,
      PhieuNhapCTString.maKho: maKho,
      PhieuNhapCTString.soLg: soLg,
      PhieuNhapCTString.donGia: donGia,
      PhieuNhapCTString.thanhTien: thanhTien,
      PhieuNhapCTString.tkKho: tkKho,
    };
  }

  factory PhieuNhapCTModel.fromMap(Map<String, dynamic> map) {
    return PhieuNhapCTModel(
        id: map[PhieuNhapCTString.id] ,
        maID: map[PhieuNhapCTString.maID] ,
        itemID: map[PhieuNhapCTString.itemID] ,
        tenHH: map[PhieuNhapCTString.tenHH] ??'',
        dvt: map[PhieuNhapCTString.dvt] ??'',
        maKho: map[PhieuNhapCTString.maKho] ,
        soLg: double.parse(map[PhieuNhapCTString.soLg].toString()) ,
        donGia: double.parse(map[PhieuNhapCTString.donGia].toString()) ,
        thanhTien: double.parse(map[PhieuNhapCTString.thanhTien].toString()) ,
        tkKho: map[PhieuNhapCTString.tkKho] ,
        maHH: map['MaHH']??''
    );
  }

}

abstract class PhieuNhapCTString{
  static const id = "ID";
  static const maID = "MaID";
  static const itemID = "ItemID";
  static const tenHH = "TenHH";
  static const dvt = "DVT";
  static const maKho = "MaKho";
  static const soLg = "SoLg";
  // static const giaVon = "GiaVon";
  static const donGia = "DonGia";
  static const thanhTien = "ThanhTien";
  static const tkG = "TKg";
  static const tkKho = "TKkho";
}


class VBCPhieuNhapModel{
  int stt;
  String kyHieu;
  String soCT;
  String ngayCT;
  String tenKH;
  String mst;
  double congTien;
  double tienThue;
  String dienGiai;

  VBCPhieuNhapModel({
    required this.stt,
    required this.kyHieu,
    required this.soCT,
    required this.ngayCT,
    required this.tenKH,
    required this.mst,
    required this.congTien,
    required this.tienThue,
    required this.dienGiai,
  });

  factory VBCPhieuNhapModel.fromMap(Map<String, dynamic> map) {
    return VBCPhieuNhapModel(
      stt: map['STT'],
      kyHieu: map[PhieuNhapString.kyHieu]??'',
      soCT: map[PhieuNhapString.soCT]??'',
      ngayCT: map[PhieuNhapString.ngayCT],
      tenKH: map['TenKH']??'',
      mst: map['MST'] ??'',
      congTien: double.parse(map[PhieuNhapString.congTien].toString()),
      tienThue: double.parse(map[PhieuNhapString.tienThue].toString()),
      dienGiai: map[PhieuNhapString.dienGiai]??'',
    );
  }

}


