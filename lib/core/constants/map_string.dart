import '../../data/data.dart';
import 'app_string.dart';

Map<String, List<String>> mQuy = {
  '1': ['01', '03'],
  '2': ['04', '06'],
  '3': ['07', '09'],
  '4': ['10', '12'],
};

Map<String,({String ma, String tableName})> mDanhMuc = {
  MenuString.danhMuc: (ma: 'TDM',tableName: TableName.nhomMC1),
  MenuString.muaBan: (ma: 'TNX',tableName: TableName.nhomMC1),
  MenuString.thuChi: (ma: 'TTC',tableName: TableName.nhomMC1),
  MenuString.congNO: (ma: 'TCN',tableName: TableName.nhomMC1),
  MenuString.khoHang: (ma: 'TKH',tableName: TableName.nhomMC1),
  MenuString.giaThanh: (ma: 'TGT',tableName: TableName.nhomMC1),
  MenuString.tienLuong: (ma: 'TLU',tableName: TableName.nhomMC1),
  MenuString.taiSan: (ma: 'TTS',tableName: TableName.nhomMC1),
  MenuString.soKeToan: (ma: 'TKT',tableName: TableName.nhomMC1),
  MenuString.heThong: (ma: 'THT',tableName: TableName.nhomMC1),
  ///=========================================================================
  MenuString.dauKy: (ma: 'TDM1',tableName: TableName.nhomMC2),
  MenuString.baoCao: (ma: 'TNX1',tableName: TableName.nhomMC2),
  MenuString.baoCaoThuChi: (ma: 'TTC1',tableName: TableName.nhomMC2),
  MenuString.nhatKy: (ma: 'TKT1',tableName: TableName.nhomMC2),
  MenuString.baoCaoTaiChinh: (ma: 'TKT2',tableName: TableName.nhomMC2),
  MenuString.baoCaoThue: (ma: 'TKT3',tableName: TableName.nhomMC2),
  ///=========================================================================
  MenuString.thongTinDoanhNghiep: (ma: 'F00_CusInfo',tableName: TableName.hangMuc),
  MenuString.danhSachNguoiDung: (ma: 'F00_DSUser',tableName: TableName.hangMuc),
  MenuString.phanQuyenNguoiDung: (ma: 'F00_PhanQuyenUser',tableName: TableName.hangMuc),
  MenuString.tuyChon: (ma: 'F00_TuyChon',tableName: TableName.hangMuc),

  MenuString.hangHoa: (ma: 'FDM_BkeHangHoa',tableName: TableName.hangMuc),
  MenuString.khachHang: (ma: 'FDM_BkeKhachHang',tableName: TableName.hangMuc),
  MenuString.nhanVien: (ma: 'FDM_BkeNhanVien',tableName: TableName.hangMuc),
  MenuString.maNghiepVu: (ma: 'FDM_MaNghiepVu',tableName: TableName.hangMuc),
  MenuString.bangTaiKhoan: (ma: 'FDM_BangTaiKhoan',tableName: TableName.hangMuc),
  MenuString.noDauKy: (ma: 'FDM_DkyKhachHang',tableName: TableName.hangMuc),
  MenuString.tonDauKy: (ma: 'FDM_DkyHangHoa',tableName: TableName.hangMuc),
  MenuString.dauKyTaiKhoan: (ma: 'FDM_DKyTaiKhoan',tableName: TableName.hangMuc),

  MenuString.muaHang: (ma: 'FNX_PhieuNhap',tableName: TableName.hangMuc),
  MenuString.banHang: (ma: 'FNX_PhieuXuat',tableName: TableName.hangMuc),
  MenuString.bangKeHoaDonMuaVao: (ma: 'FNX_BkeHoaDonMua',tableName: TableName.hangMuc),
  MenuString.bangKeHoaDonBanRa: (ma: 'FNX_BkeHoaDonBan',tableName: TableName.hangMuc),
  MenuString.bangKeHangBan: (ma: 'FNX_BkeHangBan',tableName: TableName.hangMuc),


  MenuString.phieuThu: (ma: 'FTC_PhieuThu',tableName: TableName.hangMuc),
  MenuString.phieuChi: (ma: 'FTC_PhieuChi',tableName: TableName.hangMuc),
  MenuString.bangkePhieuThu: (ma: 'FTC_BkePhieuThu',tableName: TableName.hangMuc),
  MenuString.bangkePhieuChi: (ma: 'FTC_BkePhieuChi',tableName: TableName.hangMuc),
  MenuString.soTienMat: (ma: 'FTC_SoQuyTM',tableName: TableName.hangMuc),
  MenuString.soTienGui: (ma: 'FTC_SoTGNH',tableName: TableName.hangMuc),

  MenuString.soMuaHang: (ma: 'FCN_SoMuaHang',tableName: TableName.hangMuc),
  MenuString.soBanHang: (ma: 'FCN_SoBanHang',tableName: TableName.hangMuc),
  MenuString.tongHopCongNo: (ma: 'FCN_TongHopCongNo',tableName: TableName.hangMuc),

  MenuString.bangKeHangNhap: (ma: 'FNX_BkeHangNhap',tableName: TableName.hangMuc),
  MenuString.bangKeHangXuat: (ma: 'FNX_BkeHangXuat',tableName: TableName.hangMuc),
  MenuString.nhapXuatTonKho: (ma: 'FNX_NhapXuatTon',tableName: TableName.hangMuc),

  MenuString.tinhToanGiaVon: (ma: 'FGT_TinhGiaVon',tableName: TableName.hangMuc),
  MenuString.dinhMucSanXuat: (ma: 'GT1',tableName: TableName.hangMuc),
  MenuString.bangTinhGiaThanh: (ma: 'GT2',tableName: TableName.hangMuc),
  MenuString.theTinhGiaThanh: (ma: 'GT3',tableName: TableName.hangMuc),
  MenuString.soChiPhiSXKD: (ma: 'GT4',tableName: TableName.hangMuc),

  MenuString.bangChamCong: (ma: 'FTL_BangCong',tableName: TableName.hangMuc),
  MenuString.bangThanhToanLuong: (ma: 'FTL_BangLuong',tableName: TableName.hangMuc),

  MenuString.bangKhauHaoTSCD: (ma: 'FTS_BangKHTSCD',tableName: TableName.hangMuc),
  MenuString.bangPhanBoCDCC: (ma: 'FTS_BangPBCCDC',tableName: TableName.hangMuc),
  MenuString.soNhatKyChung: (ma: 'FKT_SoNKChung',tableName: TableName.hangMuc),
  MenuString.soCaiTaiKhoan: (ma: 'FKT_SoCaiTK',tableName: TableName.hangMuc),
  MenuString.soChiTietTaiKhoan: (ma: 'FKT_SoChiTietTK',tableName: TableName.hangMuc),
  MenuString.thueTamTinh: (ma: 'FKT_ThueTNDNtt',tableName: TableName.hangMuc),
  MenuString.bangCanDoiPhatSinh: (ma: 'FKT_BangCDPS',tableName: TableName.hangMuc),
  MenuString.bangCanDoiKeToan: (ma: 'FKT_BangCDKT',tableName: TableName.hangMuc),
  MenuString.baoCaoKQKD: (ma: 'FKT_BaoCaoKQKD',tableName: TableName.hangMuc),
  MenuString.baoCaoLCTT: (ma: 'FKT_BaoCaoLCTT',tableName: TableName.hangMuc),
  MenuString.thuyetMinhBCTC: (ma: 'FKT_BaoCaoTMTC',tableName: TableName.hangMuc),
  MenuString.chuyenLo: (ma: 'FKT_ChuyenLo',tableName: TableName.hangMuc),
  MenuString.thueTNDN: (ma: 'FKT_ThueTNDN',tableName: TableName.hangMuc),
  MenuString.thueTNCN: (ma: 'FKT_ThueTNCN',tableName: TableName.hangMuc),
  MenuString.soThue: (ma: 'FKT_SoThue',tableName: TableName.hangMuc),
};


List<String> getMaNhomC1() {
  final m = mDanhMuc.entries.where((e)=>e.value.tableName==TableName.nhomMC1).map((e)=>MapEntry(e.key, e.value));
  final x = Map.fromEntries(m);
  return x.values.map((e)=>e.ma).toList();
}

List<String> getMaNhomC2() {
  final m = mDanhMuc.entries.where((e)=>e.value.tableName==TableName.nhomMC2).map((e)=>MapEntry(e.key, e.value));
  final x = Map.fromEntries(m);
  return x.values.map((e)=>e.ma).toList();
}


List<String> getMaHangMuc() {
  final m = mDanhMuc.entries.where((e)=>e.value.tableName==TableName.hangMuc).map((e)=>MapEntry(e.key, e.value));
  final x = Map.fromEntries(m);
  return x.values.map((e)=>e.ma).toList();
}