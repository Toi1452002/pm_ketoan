class PhieuChiModel{
  final int? id;
  final String phieu;
  final String? ngay;
  final String? maTC;
  final String? maKhach;
  final String? maNV;
  String? tenKhach;
  String? diaChi;
  String? nguoiChi;
  String? nguoiNhan;
  final double? soTien;
  String? noiDung;
  final String? pttt;
  // final String soTK;
  final bool khoa;
  final String? createdBy;
  final String? createdAt;
  final String? updatedBy;
  final String? updatedAt;
  final String? tkNo;
  final String? tkCo;
  final int? stt;
  final String? countRow;
  String? soCT;
  PhieuChiModel({
    this.id,
    required this.phieu,
    this.ngay,
    this.maTC,
    this.maKhach,
    this.maNV,
    this.tenKhach,
    this.diaChi,
    this.nguoiChi,
    this.nguoiNhan,
    this.soTien,
    this.noiDung,
    this.pttt,
    required this.khoa,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.tkNo,
    this.tkCo,
    this.stt,
    this.countRow,
    this.soCT
  });

  Map<String, dynamic> toMap() {
    return {
      PhieuChiString.id: id,
      PhieuChiString.phieu: phieu,
      PhieuChiString.ngay: ngay,
      PhieuChiString.maTC: maTC,
      PhieuChiString.maKhach: maKhach,
      PhieuChiString.maNV: maNV,
      PhieuChiString.tenKhach: tenKhach,
      PhieuChiString.diaChi: diaChi,
      PhieuChiString.nguoiChi: nguoiChi,
      PhieuChiString.nguoiNhan: nguoiNhan,
      PhieuChiString.soTien: soTien,
      PhieuChiString.noiDung: noiDung,
      PhieuChiString.pttt: pttt,
      PhieuChiString.khoa: khoa!?1:0,
      PhieuChiString.createdBy: createdBy,
      PhieuChiString.createdAt: createdAt,
      PhieuChiString.updatedBy: updatedBy,
      PhieuChiString.updatedAt: updatedAt,
      PhieuChiString.tkNo: tkNo,
      PhieuChiString.tkCo: tkCo,

    };
  }

  factory PhieuChiModel.fromMap(Map<String, dynamic> map) {
    return PhieuChiModel(
        id: map[PhieuChiString.id] ,
        phieu: map[PhieuChiString.phieu] ,
        ngay: map[PhieuChiString.ngay] ,
        maTC: map[PhieuChiString.maTC] ??'',
        maKhach: map[PhieuChiString.maKhach]??'' ,
        maNV: map[PhieuChiString.maNV] ,
        tenKhach: map[PhieuChiString.tenKhach]??'',
        diaChi: map[PhieuChiString.diaChi] ??'',
        nguoiChi: map[PhieuChiString.nguoiChi]??'' ,
        nguoiNhan: map[PhieuChiString.nguoiNhan] ??'',
        soTien: double.parse(map[PhieuChiString.soTien].toString()),
        noiDung: map[PhieuChiString.noiDung] ??'',
        pttt: map[PhieuChiString.pttt] ,
        khoa: map[PhieuChiString.khoa] == 1 ? true : false,
        createdBy: map[PhieuChiString.createdBy] ,
        createdAt: map[PhieuChiString.createdAt] ,
        updatedBy: map[PhieuChiString.updatedBy] ,
        updatedAt: map[PhieuChiString.updatedAt] ,
        tkNo: map[PhieuChiString.tkNo] ??'',
        tkCo: map[PhieuChiString.tkCo] ??'',
        stt:  map['STT'],
        soCT: map[PhieuChiString.soCT]
    );
  }

  PhieuChiModel copyWith({
    int? id,
    String? phieu,
    String? ngay,
    String? maTC,
    String? maKhach,
    String? maNV,
    String? tenKhach,
    String? diaChi,
    String? nguonChi,
    String? nguoiNhan,
    double? soTien,
    String? noiDung,
    String? pttt,
    bool? khoa,
    String? createdBy,
    String? createdAt,
    String? updatedBy,
    String? updatedAt,
    String? tkNo,
    String? tkCo,
    int? stt,
    String? countRow,
    String? soCT
  }) {
    return PhieuChiModel(
      id: id ?? this.id,
      phieu: phieu ?? this.phieu,
      ngay: ngay ?? this.ngay,
      maTC: maTC ?? this.maTC,
      maKhach: maKhach ?? this.maKhach,
      maNV: maNV ?? this.maNV,
      tenKhach: tenKhach ?? this.tenKhach,
      diaChi: diaChi ?? this.diaChi,
      nguoiChi: nguonChi ?? this.nguoiChi,
      nguoiNhan: nguoiNhan ?? this.nguoiNhan,
      soTien: soTien ?? this.soTien,
      noiDung: noiDung ?? this.noiDung,
      pttt: pttt ?? this.pttt,
      khoa: khoa ?? this.khoa,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      tkNo: tkNo ?? this.tkNo,
      tkCo: tkCo ?? this.tkCo,
      stt: stt ?? this.stt,
      countRow: countRow ?? this.countRow,
      soCT: soCT ?? this.soCT,
    );
  }
}


abstract class PhieuChiString{
  static const id =  'ID';
  static const phieu =  'Phieu';
  static const ngay =  'Ngay';
  static const maTC =  'MaTC';
  static const maKhach =  'MaKhach';
  static const maNV =  'MaNV';
  static const tenKhach =  'TenKhach';
  static const diaChi =  'DiaChi';
  static const nguoiChi =  'NguoiChi';
  static const nguoiNhan =  'NguoiNhan';
  static const soTien =  'SoTien';
  static const noiDung =  'NoiDung';
  static const pttt =  'PTTT';
  static const khoa =  'Khoa';
  static const createdBy =  'CreatedBy';
  static const createdAt =  'CreatedAt';
  static const updatedBy =  'UpdatedBy';
  static const updatedAt =  'UpdatedAt';
  static const tkNo =  'TKNo';
  static const tkCo =  'TKCo';
  static const soCT = 'SoCT';
}



class PhieuChiCTModel{
  final int? id;
  final int? maID;
  final String? dienGiai;
  final double soTien;
  final String? ctBan;

  const PhieuChiCTModel({
    this.id,
    this.maID,
    this.dienGiai,
    required this.soTien,
    this.ctBan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'maID': maID,
      'dienGiai': dienGiai,
      'soTien': soTien,
      'ctBan': ctBan,
    };
  }

  factory PhieuChiCTModel.fromMap(Map<String, dynamic> map) {
    return PhieuChiCTModel(
      id: map[PhieuChiCTString.id] ,
      maID: map[PhieuChiCTString.maID] ,
      dienGiai: map[PhieuChiCTString.dienGiai] ??'',
      soTien: double.parse(map[PhieuChiCTString.soTien].toString()) ,
      // ctBan: map[PhieuChiCTString.ctBan] ,
    );
  }
}

abstract class PhieuChiCTString{
  static const id = "ID";
  static const maID = "MaID";
  static const dienGiai = "DienGiai";
  static const soTien = "SoTien";
  static const ctBan = "CTBan";
}