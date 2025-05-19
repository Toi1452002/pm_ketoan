import '../../core/constants/constants.dart';

class PhieuThuModel {
  final int? id;
  final String phieu;
  final String ngay;
  final String? maTC;
  final String? maKhach;
  String? tenKhach;
  String? diaChi;
  String? nguoiNop;
  String? nguoiThu;
  final double? soTien;
  String? noiDung;
  final String? pttt;

  // final String soTK;
  final bool khoa;
  final String? createdAt;
  final String? createdBy;
  final String? updatedAt;
  final String? updatedBy;
  String? soCT;
  final String tkNo;
  final String tkCo;
  final int? stt;
  final String? countRow;
  PhieuThuModel({
    this.id,
    required this.phieu,
    required this.ngay,
    this.maTC,
    this.maKhach,
    this.tenKhach,
    this.diaChi,
    this.nguoiNop,
    this.nguoiThu,
    this.soTien,
    this.noiDung,
    this.pttt,
    // required this.soTK,
    required this.khoa,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    required this.soCT,
    required this.tkNo,
    required this.tkCo,
    this.stt = 0,
    this.countRow
  });

  Map<String, dynamic> toMap() {
    return {
      PhieuThuString.id: id,
      PhieuThuString.phieu: phieu,
      PhieuThuString.ngay: ngay,
      PhieuThuString.maTC: maTC,
      PhieuThuString.maKhach: maKhach,
      PhieuThuString.tenKhach: tenKhach,
      PhieuThuString.diaChi: diaChi,
      PhieuThuString.nguoiNop: nguoiNop,
      PhieuThuString.nguoiThu: nguoiThu,
      PhieuThuString.soTien: soTien,
      PhieuThuString.noiDung: noiDung,
      PhieuThuString.pttt: pttt,
      // TablePhieuThu.soTK: soTK,
      PhieuThuString.khoa: khoa ? 1 : 0,
      // TablePhieuThu.createdAt: createdAt,
      PhieuThuString.createdBy: createdBy,
      PhieuThuString.updatedAt: updatedAt,
      PhieuThuString.updatedBy: updatedBy,
      PhieuThuString.soCT: soCT,
      PhieuThuString.tkNo: tkNo,
      PhieuThuString.tkCo: tkCo,
    };
  }

  factory PhieuThuModel.fromMap(Map<String, dynamic> map) {
    return PhieuThuModel(
        id: map[PhieuThuString.id],
        phieu: map[PhieuThuString.phieu],
        ngay: map[PhieuThuString.ngay],
        maTC: map[PhieuThuString.maTC]??'',
        maKhach: map[PhieuThuString.maKhach]??'',
        tenKhach: map[PhieuThuString.tenKhach]??'',
        diaChi: map[PhieuThuString.diaChi]??'',
        nguoiNop: map[PhieuThuString.nguoiNop]??'',
        nguoiThu: map[PhieuThuString.nguoiThu]??'',
        soTien: double.parse(map[PhieuThuString.soTien].toString()),
        noiDung: map[PhieuThuString.noiDung]??'',
        pttt: map[PhieuThuString.pttt]??'',
        // soTK: map[TablePhieuThu.soTK]  ,
        khoa: map[PhieuThuString.khoa] == 1 ? true : false,
        createdAt: map[PhieuThuString.createdAt],
        createdBy: map[PhieuThuString.createdBy],
        updatedAt: map[PhieuThuString.updatedAt],
        updatedBy: map[PhieuThuString.updatedBy],
        soCT: map[PhieuThuString.soCT],
        tkNo: map[PhieuThuString.tkNo]??'',
        tkCo: map[PhieuThuString.tkCo]??'',
        stt:  map['STT']??0
    );
  }

  PhieuThuModel copyWith({
    int? id,
    String? phieu,
    String? ngay,
    String? maTC,
    String? maKhach,
    String? tenKhach,
    String? diaChi,
    String? nguoiNop,
    String? nguoiThu,
    double? soTien,
    String? noiDung,
    String? pttt,
    String? soTK,
    bool? khoa,
    String? createdAt,
    String? createdBy,
    String? updatedAt,
    String? updatedBy,
    String? soCT,
    String? tkNo,
    String? tkCo,
    String? countRow,
    int? stt
  }) {
    return PhieuThuModel(
        id: id ?? this.id,
        phieu: phieu ?? this.phieu,
        ngay: ngay ?? this.ngay,
        maTC: maTC ?? this.maTC,
        maKhach: maKhach ?? this.maKhach,
        tenKhach: tenKhach ?? this.tenKhach,
        diaChi: diaChi ?? this.diaChi,
        nguoiNop: nguoiNop ?? this.nguoiNop,
        nguoiThu: nguoiThu ?? this.nguoiThu,
        soTien: soTien ?? this.soTien,
        noiDung: noiDung ?? this.noiDung,
        pttt: pttt ?? this.pttt,
        // soTK: soTK ?? this.soTK,
        khoa: khoa ?? this.khoa,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        soCT: soCT ?? this.soCT,
        tkNo: tkNo ?? this.tkNo,
        tkCo: tkCo ?? this.tkCo,
        countRow:  countRow ?? this.countRow,
        stt:  stt?? this.stt
    );
  }
}

abstract class PhieuThuString{
  static const id = "ID";
  static const phieu = "Phieu";
  static const ngay = "Ngay";
  static const maTC = "MaTC";
  static const maKhach = "MaKhach";
  static const tenKhach = "TenKhach";
  static const diaChi = "DiaChi";
  static const nguoiNop = "NguoiNop";
  static const nguoiThu = "NguoiThu";
  static const soTien = "SoTien";
  static const noiDung  = "NoiDung";
  static const pttt = "PTTT";
  static const soTK = "SoTK";
  static const khoa = "Khoa";
  static const createdAt = "CreatedAt";
  static const createdBy = "CreatedBy";
  static const updatedAt = "UpdatedAt";
  static const updatedBy = "UpdatedBy";
  static const soCT = "SoCT";
  static const tkNo = "TKNo";
  static const tkCo = "TKCo";
}


class PhieuThuChiTietModel{
  final int? id;
  final int? maID;
  final String dienGiai;
  final double soTien;

  const PhieuThuChiTietModel({
    this.id,
    this.maID,
    required this.dienGiai,
    required this.soTien,
  });



  PhieuThuChiTietModel copyWith({
    int? id,
    int? maID,
    String? dienGiai,
    double? soTien,
  }) {
    return PhieuThuChiTietModel(
      id: id ?? this.id,
      maID: maID ?? this.maID,
      dienGiai: dienGiai ?? this.dienGiai,
      soTien: soTien ?? this.soTien,
    );
  }


  factory PhieuThuChiTietModel.fromMap(Map<String, dynamic> map) {
    return PhieuThuChiTietModel(
      id: map[PhieuThuCTString.id] ,
      maID: map[PhieuThuCTString.maID] ,
      dienGiai: map[PhieuThuCTString.dienGiai]??'',
      soTien: double.parse(map[PhieuThuCTString.soTien].toString()),
    );
  }
}

abstract class PhieuThuCTString{
  static const id = "ID";
  static const maID = "MaID";
  static const dienGiai = "DienGiai";
  static const soTien = "SoTien";
  static const ctBan = "CTBan";
  static const ngay = "Ngay";
}