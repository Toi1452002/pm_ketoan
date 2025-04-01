class HangHoaModel {
  final int? id;
  final String maHH;
  final String tenHH;
  final int? dvtID;
  final int? loaiHHID;
  final int? nhomID;
  final double giaMua;
  final double giaBan;
  final String? maNC;
  final String ghiChu;
  final bool tinhTon;
  final String? createdAt;
  final String? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final bool theoDoi;
  final String tkKho;
  final String? donViTinh;
  final String? loaiHang;
  final String? nhomHang;

  const HangHoaModel({
    this.id,
    this.dvtID,
    this.loaiHHID,
    this.nhomID,
    this.maNC,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    this.donViTinh,
    this.loaiHang,
    this.nhomHang,
    required this.maHH,
    required this.tenHH,
    required this.giaMua,
    required this.giaBan,
    required this.ghiChu,
    required this.tinhTon,
    this.createdBy,
    required this.theoDoi,
    required this.tkKho,
  });

  Map<String, dynamic> toMap() {
    return {
      HangHoaString.id: id,
      HangHoaString.maHH: maHH.trim(),
      HangHoaString.tenHH: tenHH,
      HangHoaString.dvtID: dvtID,
      HangHoaString.loaiHHID: loaiHHID,
      HangHoaString.nhomID: nhomID,
      HangHoaString.giaMua: giaMua,
      HangHoaString.giaBan: giaBan,
      HangHoaString.maNC: maNC,
      HangHoaString.ghiChu: ghiChu,
      HangHoaString.tinhTon: tinhTon ? 1 : 0,
      HangHoaString.updatedAt: updatedAt,
      HangHoaString.createdBy: createdBy,
      HangHoaString.updatedBy: updatedBy,
      HangHoaString.theoDoi: theoDoi ? 1 : 0,
      HangHoaString.tkKho: tkKho,
    };
  }

  factory HangHoaModel.fromMap(Map<String, dynamic> map) {
    return HangHoaModel(
        id: map[HangHoaString.id],
        maHH: map[HangHoaString.maHH],
        tenHH: map[HangHoaString.tenHH] ?? '',
        dvtID: map[HangHoaString.dvtID],
        loaiHHID: map[HangHoaString.loaiHHID],
        nhomID: map[HangHoaString.nhomID],
        giaMua: double.parse(map[HangHoaString.giaMua].toString()) ?? 0,
        giaBan: double.parse(map[HangHoaString.giaBan].toString()) ?? 0,
        maNC: map[HangHoaString.maNC] ?? '',
        ghiChu: map[HangHoaString.ghiChu] ?? '',
        tinhTon: map[HangHoaString.tinhTon] == 1 ? true : false,
        createdAt: map[HangHoaString.createdAt] ?? '',
        updatedAt: map[HangHoaString.updatedAt] ?? '',
        createdBy: map[HangHoaString.createdBy] ?? '',
        updatedBy: map[HangHoaString.updatedBy] ?? '',
        theoDoi: map[HangHoaString.theoDoi] == 1 ? true : false,
        tkKho: map[HangHoaString.tkKho].toString(),
        donViTinh: map[DVTString.dvt] ?? '',
        nhomHang: map[NhomHangString.nhomHang] ?? '',
        loaiHang: map[LoaiHangString.loaiHang] ?? '');
  }

  HangHoaModel copyWith({
    int? id,
    String? maHH,
    String? tenHH,
    int? dvtID,
    int? loaiHHID,
    int? nhomID,
    double? giaMua,
    double? giaBan,
    String? maNC,
    String? ghiChu,
    bool? tinhTon,
    String? createdAt,
    String? updatedAt,
    String? createdBy,
    String? updatedBy,
    bool? theoDoi,
    String? tkKho,
  }) {
    return HangHoaModel(
      id: id ?? this.id,
      maHH: maHH ?? this.maHH,
      tenHH: tenHH ?? this.tenHH,
      dvtID: dvtID ?? this.dvtID,
      loaiHHID: loaiHHID ?? this.loaiHHID,
      nhomID: nhomID ?? this.nhomID,
      giaMua: giaMua ?? this.giaMua,
      giaBan: giaBan ?? this.giaBan,
      maNC: maNC ?? this.maNC,
      ghiChu: ghiChu ?? this.ghiChu,
      tinhTon: tinhTon ?? this.tinhTon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      theoDoi: theoDoi ?? this.theoDoi,
      tkKho: tkKho ?? this.tkKho,
    );
  }
}

class DonViTinhModel {
  final int? id;
  final String dvt;

  const DonViTinhModel({
    this.id,
    required this.dvt,
  });

  factory DonViTinhModel.fromMap(Map<String, dynamic> map) {
    return DonViTinhModel(
      id: map[DVTString.id],
      dvt: map[DVTString.dvt] ?? '',
    );
  }
}

class LoaiHangModel {
  final int? id;
  final String loaiHang;

  const LoaiHangModel({
    this.id,
    required this.loaiHang,
  });

  factory LoaiHangModel.fromMap(Map<String, dynamic> map) {
    return LoaiHangModel(
      id: map[LoaiHangString.id],
      loaiHang: map[LoaiHangString.loaiHang] ?? '',
    );
  }
}

class NhomHangModel {
  final int? id;
  final String nhomHang;

  const NhomHangModel({
    this.id,
    required this.nhomHang,
  });

  factory NhomHangModel.fromMap(Map<String, dynamic> map) {
    return NhomHangModel(
      id: map[NhomHangString.id],
      nhomHang: map[NhomHangString.nhomHang] ?? '',
    );
  }
}


abstract class HangHoaString{
  static const id = "ID";
  static const maHH = "MaHH";
  static const tenHH = "TenHH";
  static const dvtID = "DVTID";
  static const loaiHHID = "LoaiHHID";
  static const nhomID = "NhomID";
  static const giaMua = "GiaMua";
  static const giaVon = "GiaVon";
  static const giaBan = "GiaBan";
  static const maNC = "MaNC";
  static const ghiChu = "GhiChu";
  static const tinhTon = "TinhTon";
  static const createdAt = "CreatedAt";
  static const createdBy = "CreatedBy";
  static const updatedAt = "UpdatedAt";
  static const updatedBy = "UpdatedBy";
  static const theoDoi = "TheoDoi";
  static const tkKho = "TKkho";
}

abstract class NhomHangString{
  static const id = "ID";
  static const nhomHang = "NhomHang";
}

abstract class LoaiHangString{
  static const id = "ID";
  static const loaiHang = "LoaiHang";
}

abstract class DVTString {
  static const id = "ID";
  static const dvt = "DVT";
}
