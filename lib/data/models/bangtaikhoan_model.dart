
class BangTaiKhoanModel{
  final String maTK;
  final String tenTK;
  final bool maXL;
  final String tinhChat;
  final String maLK;
  final String ghiChu;

  const BangTaiKhoanModel({
    required this.maTK,
    required this.tenTK,
    required this.maXL,
    required this.tinhChat,
    required this.maLK,
    required this.ghiChu,
  });

  factory BangTaiKhoanModel.fromMap(Map<String, dynamic> map) {
    return BangTaiKhoanModel(
      maTK: map[BangTaiKhoanString.maTK]??'',
      tenTK: map[BangTaiKhoanString.tenTK]??'',
      maXL: map[BangTaiKhoanString.maXL]==1?true: false,
      tinhChat: map[BangTaiKhoanString.tinhChat]??'',
      maLK: map[BangTaiKhoanString.maLK]??'',
      ghiChu: map[BangTaiKhoanString.ghiChu]??'',
    );
  }
}

abstract class BangTaiKhoanString{
  static const maTK = "MaTK";
  static const tenTK = "TenTK";
  static const maXL = "MaXL";
  static const tinhChat = "TinhChat";
  static const maLK = "MaLK";
  static const ghiChu = "GhiChu";
}