class NhanVienModel {
  final int? id;
  final String maNV;
  final String hoTen;
  final bool phai;
  final String? ngaySinh;
  final String cccd;
  final String mst;
  final String diaChi;
  final String dienThoai;
  final String trinhDo;
  final String chuyenMon;
  final String? ngayVao;
  final String chucDanh;
  final double luongCB;
  final bool thoiVu;
  final bool khongCuTru;
  final bool coCk;
  final String ghiChu;
  final bool theoDoi;

  const NhanVienModel({
    this.id,
    required this.maNV,
    required this.hoTen,
    this.phai = false,
    this.ngaySinh,
    this.cccd='',
    this.mst='',
    this.diaChi='',
    this.dienThoai='',
    this.trinhDo='',
    this.chuyenMon='',
    this.ngayVao,
    this.chucDanh='',
    this.luongCB = 0,
    required this.thoiVu,
    required this.khongCuTru,
    required this.coCk ,
    this.ghiChu = '',
    this.theoDoi = true,
  });

  Map<String, dynamic> toMap() {
    return {
      NhanVienString.id: id,
      NhanVienString.maNV: maNV,
      NhanVienString.hoTen: hoTen,
      NhanVienString.phai: phai?1: 0,
      NhanVienString.ngaySinh: ngaySinh,
      NhanVienString.cccd: cccd,
      NhanVienString.mst: mst,
      NhanVienString.diaChi: diaChi,
      NhanVienString.dienThoai: dienThoai,
      NhanVienString.trinhDo: trinhDo,
      NhanVienString.chuyenMon: chuyenMon,
      NhanVienString.ngayVao: ngayVao,
      NhanVienString.chucDanh: chucDanh,
      NhanVienString.luongCB: luongCB,
      NhanVienString.thoiVu: thoiVu?1: 0,
      NhanVienString.khongCuTru: khongCuTru?1: 0,
      NhanVienString.coCK: coCk ?1: 0,
      NhanVienString.ghiChu: ghiChu,
      NhanVienString.theoDoi: theoDoi?1:0,
    };
  }

  factory NhanVienModel.fromMap(Map<String, dynamic> map) {
    return NhanVienModel(
      id: map[NhanVienString.id],
      maNV: map[NhanVienString.maNV],
      hoTen: map[NhanVienString.hoTen]??'',
      phai: map[NhanVienString.phai]==1?true:false,
      ngaySinh: map[NhanVienString.ngaySinh]??'',
      cccd: map[NhanVienString.cccd]??'',
      mst: map[NhanVienString.mst]??'',
      diaChi: map[NhanVienString.diaChi]??'',
      dienThoai: map[NhanVienString.dienThoai]??'',
      trinhDo: map[NhanVienString.trinhDo]??'',
      chuyenMon: map[NhanVienString.chuyenMon]??'',
      ngayVao: map[NhanVienString.ngayVao]??'',
      chucDanh: map[NhanVienString.chucDanh]??'',
      luongCB: double.parse(map[NhanVienString.luongCB].toString()),
      thoiVu: map[NhanVienString.thoiVu]==1?true:false,
      khongCuTru: map[NhanVienString.khongCuTru]==1?true:false,
      coCk: map[NhanVienString.coCK]==1?true:false,
      ghiChu: map[NhanVienString.ghiChu]??'',
      theoDoi: map[NhanVienString.theoDoi]==1?true:false,
    );
  }

  NhanVienModel copyWith({
    int? id,
    String? maNV,
    String? hoTen,
    bool? phai,
    String? ngaySinh,
    String? cccd,
    String? mst,
    String? diaChi,
    String? dienThoai,
    String? trinhDo,
    String? chuyenMon,
    String? ngayVao,
    String? chucDanh,
    double? luongCB,
    bool? thoiVu,
    bool? khongCuTru,
    bool? coCk,
    String? ghiChu,
    bool? theoDoi,
  }) {
    return NhanVienModel(
      id: id ?? this.id,
      maNV: maNV ?? this.maNV,
      hoTen: hoTen ?? this.hoTen,
      phai: phai ?? this.phai,
      ngaySinh: ngaySinh ?? this.ngaySinh,
      cccd: cccd ?? this.cccd,
      mst: mst ?? this.mst,
      diaChi: diaChi ?? this.diaChi,
      dienThoai: dienThoai ?? this.dienThoai,
      trinhDo: trinhDo ?? this.trinhDo,
      chuyenMon: chuyenMon ?? this.chuyenMon,
      ngayVao: ngayVao ?? this.ngayVao,
      chucDanh: chucDanh ?? this.chucDanh,
      luongCB: luongCB ?? this.luongCB,
      thoiVu: thoiVu ?? this.thoiVu,
      khongCuTru: khongCuTru ?? this.khongCuTru,
      coCk: coCk ?? this.coCk,
      ghiChu: ghiChu ?? this.ghiChu,
      theoDoi: theoDoi ?? this.theoDoi,
    );
  }
}
abstract class NhanVienString {
  static const id = "ID";
  static const maNV = "MaNV";
  static const hoTen = "HoTen";
  static const phai = "Phai";
  static const ngaySinh = "NgaySinh";
  static const cccd = "CCCD";
  static const mst = "MST";
  static const diaChi = "DiaChi";
  static const dienThoai = "DienThoai";
  static const trinhDo = "TrinhDo";
  static const chuyenMon = "ChuyenMon";
  static const ngayVao = "NgayVao";
  static const chucDanh = "ChucDanh";
  static const luongCB = "LuongCB";
  static const thoiVu = "ThoiVu";
  static const khongCuTru = "KhongCuTru";
  static const coCK = "CoCK";
  static const ghiChu = "GhiChu";
  static const theoDoi = "TheoDoi";
}