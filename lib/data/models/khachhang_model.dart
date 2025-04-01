class KhachHangModel {
  final String maKhach;
  final String tenKH;
  final String diaChi;
  final String dienThoai;
  final String diDong;
  final String fax;
  final String email;
  final String mst;
  final String soTK;
  final String nganHang;
  final String ghiChu;
  final String? maNhom;
  final String? loaiKH;
  final bool theoDoi;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;

  const KhachHangModel({
    required this.maKhach,
    required this.tenKH,
    this.diaChi='',
    this.dienThoai='',
    this.diDong='',
    this.fax='',
    this.email='',
    this.mst='',
    this.soTK='',
    this.nganHang='',
    this.ghiChu = '',
    this.maNhom,
    this.loaiKH,
    this.theoDoi = true,
    this.createdAt = '',
    this.createdBy = '',
    this.updatedAt = '',
    this.updatedBy = '',
  });

  Map<String, dynamic> toMap() {
    return {
      KhachHangString.maKhach: maKhach,
      KhachHangString.tenKH: tenKH,
      KhachHangString.diaChi: diaChi,
      KhachHangString.dienThoai: dienThoai,
      KhachHangString.diDong: diDong,
      KhachHangString.fax: fax,
      KhachHangString.email: email,
      KhachHangString.mst: mst,
      KhachHangString.soTK: soTK,
      KhachHangString.nganHang: nganHang,
      KhachHangString.ghiChu: ghiChu,
      KhachHangString.maNhom: maNhom!.isEmpty ? null : maNhom,
      KhachHangString.loaiKH: loaiKH,
      KhachHangString.theoDoi: theoDoi ? 1 : 0,
      // TableKhachHang.createdAt: null,
      KhachHangString.createdBy: createdBy,
      KhachHangString.updatedAt: updatedAt,
      KhachHangString.updatedBy: updatedBy,
    };
  }

  factory KhachHangModel.fromMap(Map<String, dynamic> map) {
    return KhachHangModel(
      maKhach: map[KhachHangString.maKhach],
      tenKH: map[KhachHangString.tenKH]??'' ,
      diaChi: map[KhachHangString.diaChi]??'',
      dienThoai: map[KhachHangString.dienThoai]??'',
      diDong: map[KhachHangString.diDong] ??'',
      fax: map[KhachHangString.fax] ??'',
      email: map[KhachHangString.email] ??'',
      mst: map[KhachHangString.mst] ??'',
      soTK: map[KhachHangString.soTK] ??'',
      nganHang: map[KhachHangString.nganHang] ??'',
      ghiChu: map[KhachHangString.ghiChu] ??'',
      maNhom: map[KhachHangString.maNhom] ??'',
      loaiKH: map[KhachHangString.loaiKH]??'',
      theoDoi: map[KhachHangString.theoDoi]==1 ? true : false,
      createdAt: map[KhachHangString.createdAt]??'',
      createdBy: map[KhachHangString.createdBy]??'',
      updatedAt: map[KhachHangString.updatedAt] ??'',
      updatedBy: map[KhachHangString.updatedBy] ??'',
    );
  }

  KhachHangModel copyWith({
    String? maKhach,
    String? tenKH,
    String? diaChi,
    String? dienThoai,
    String? diDong,
    String? fax,
    String? email,
    String? mst,
    String? soTK,
    String? nganHang,
    String? ghiChu,
    String? maNhom,
    String? loaiKH,
    bool? theoDoi,
    String? createdAt,
    String? createdBy,
    String? updatedAt,
    String? updatedBy,
  }) {
    return KhachHangModel(
      maKhach: maKhach ?? this.maKhach,
      tenKH: tenKH ?? this.tenKH,
      diaChi: diaChi ?? this.diaChi,
      dienThoai: dienThoai ?? this.dienThoai,
      diDong: diDong ?? this.diDong,
      fax: fax ?? this.fax,
      email: email ?? this.email,
      mst: mst ?? this.mst,
      soTK: soTK ?? this.soTK,
      nganHang: nganHang ?? this.nganHang,
      ghiChu: ghiChu ?? this.ghiChu,
      maNhom: maNhom ?? this.maNhom,
      loaiKH: loaiKH ?? this.loaiKH,
      theoDoi: theoDoi ?? this.theoDoi,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}

abstract class KhachHangString {
  static const maKhach = "MaKhach";
  static const tenKH = "TenKH";
  static const diaChi = "DiaChi";
  static const dienThoai = "DienThoai";
  static const diDong = "DiDong";
  static const fax = "Fax";
  static const email = "Email";
  static const mst = "MST";
  static const soTK = "SoTK";
  static const nganHang = "NganHang";
  static const ghiChu = "GhiChu";
  static const maNhom = "MaNhom";
  static const loaiKH = "LoaiKH";
  static const theoDoi = "TheoDoi";
  static const createdAt = "CreatedAt";
  static const createdBy = "CreatedBy";
  static const updatedAt = "UpdatedAt";
  static const updatedBy = "UpdatedBy";
}

class NhomKhachModel{
  final int? id;
  final String maNhom;
  final String tenNhom;

  const NhomKhachModel({
    this.id,
    required this.maNhom,
    required this.tenNhom,
  });


  factory NhomKhachModel.fromMap(Map<String, dynamic> map) {
    return NhomKhachModel(
      id: map[NhomKhachString.id] as int,
      maNhom: map[NhomKhachString.maNhom]??'',
      tenNhom: map[NhomKhachString.tenNhom]??'',
    );
  }
}

abstract class NhomKhachString {
  static const id = "ID";
  static const maNhom = "MaNhom";
  static const tenNhom = "TenNhom";
}