import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../core/constants/constants.dart';

final tuyChonProvider = StateNotifierProvider<TuyChonNotifier, List<TuyChonModel>>((ref) {
  return TuyChonNotifier();
});

final nhomMaC1Provider = StateNotifierProvider<NhomMC1Notifier, List<MaDMModel>>((ref) {
  return NhomMC1Notifier();
});
final nhomMaC2Provider = StateNotifierProvider<NhomMC2Notifier, List<MaDMModel>>((ref) {
  return NhomMC2Notifier();
});
final hangMucProvider = StateNotifierProvider<HangMucNotifier, List<MaDMModel>>((ref) {
  return HangMucNotifier();
});

final listMenuProvider = StateProvider.autoDispose<List<TreeNode<String>>>((ref) {
  final wMaMC1Provider = ref.watch(nhomMaC1Provider);
  final wMaMC2Provider = ref.watch(nhomMaC2Provider);
  final wHangMuc = ref.watch(hangMucProvider);

  return [
    ///DANH MUC
    if (wMaMC1Provider[0].choPhep)
      TreeItem(
        data: MenuString.danhMuc,
        children: [
          if (wHangMuc[4].choPhep) TreeItem(data: MenuString.hangHoa),
          if (wHangMuc[5].choPhep) TreeItem(data: MenuString.khachHang),
          if (wHangMuc[6].choPhep) TreeItem(data: MenuString.nhanVien),
          if (wHangMuc[7].choPhep) TreeItem(data: MenuString.maNghiepVu),
          if (wHangMuc[8].choPhep) TreeItem(data: MenuString.bangTaiKhoan),
          if (wMaMC2Provider[0].choPhep)
            TreeItem(
              data: MenuString.dauKy,
              children: [
                if (wHangMuc[9].choPhep) TreeItem(data: MenuString.noDauKy),
                if (wHangMuc[10].choPhep) TreeItem(data: MenuString.tonDauKy),
                if (wHangMuc[11].choPhep) TreeItem(data: MenuString.dauKyTaiKhoan),
              ],
            ),
        ],
      ),

    ///MUA BAN
    if (wMaMC1Provider[1].choPhep)
      TreeItem(
        data: MenuString.muaBan,
        children: [
          if (wHangMuc[12].choPhep) TreeItem(data: MenuString.muaHang),
          if (wHangMuc[13].choPhep) TreeItem(data: MenuString.banHang),
          if (wMaMC2Provider[1].choPhep)
            TreeItem(
              data: MenuString.baoCao,
              children: [
                if (wHangMuc[14].choPhep) TreeItem(data: MenuString.bangKeHoaDonMuaVao),
                if (wHangMuc[15].choPhep) TreeItem(data: MenuString.bangKeHoaDonBanRa),
                if (wHangMuc[16].choPhep) TreeItem(data: MenuString.bangKeHangBan),
              ],
            ),
        ],
      ),

    ///THU CHI
    if (wMaMC1Provider[2].choPhep)
      TreeItem(
        data: MenuString.thuChi,
        children: [
          if (wHangMuc[17].choPhep) TreeItem(data: MenuString.phieuThu),
          if (wHangMuc[18].choPhep) TreeItem(data: MenuString.phieuChi),
          if (wMaMC2Provider[2].choPhep)
            TreeItem(
              data: MenuString.baoCaoThuChi,
              children: [
                if (wHangMuc[19].choPhep) TreeItem(data: MenuString.bangkePhieuThu),
                if (wHangMuc[20].choPhep) TreeItem(data: MenuString.bangkePhieuChi),
                if (wHangMuc[21].choPhep) TreeItem(data: MenuString.soTienMat),
                if (wHangMuc[22].choPhep) TreeItem(data: MenuString.soTienGui),
              ],
            ),
        ],
      ),

    ///CONG NO
    if (wMaMC1Provider[3].choPhep)
      TreeItem(
        data: MenuString.congNO,
        children: [
          if (wHangMuc[23].choPhep) TreeItem(data: MenuString.soMuaHang),
          if (wHangMuc[24].choPhep) TreeItem(data: MenuString.soBanHang),
          if (wHangMuc[25].choPhep) TreeItem(data: MenuString.tongHopCongNo),
        ],
      ),

    ///KHO HANG
    if (wMaMC1Provider[4].choPhep)
      TreeItem(
        data: MenuString.khoHang,
        children: [
          if (wHangMuc[26].choPhep) TreeItem(data: MenuString.bangKeHangNhap),
          if (wHangMuc[27].choPhep) TreeItem(data: MenuString.bangKeHangXuat),
          if (wHangMuc[28].choPhep) TreeItem(data: MenuString.nhapXuatTonKho),
        ],
      ),

    ///GIA THANH
    if (wMaMC1Provider[5].choPhep)
      TreeItem(
        data: MenuString.giaThanh,
        children: [
          if (wHangMuc[29].choPhep) TreeItem(data: MenuString.tinhToanGiaVon),
          if (wHangMuc[30].choPhep) TreeItem(data: MenuString.dinhMucSanXuat),
          if (wHangMuc[31].choPhep) TreeItem(data: MenuString.bangTinhGiaThanh),
          if (wHangMuc[32].choPhep) TreeItem(data: MenuString.theTinhGiaThanh),
          if (wHangMuc[33].choPhep) TreeItem(data: MenuString.soChiPhiSXKD),
        ],
      ),

    ///TIEN LUONG
    if (wMaMC1Provider[6].choPhep)
      TreeItem(
        data: MenuString.tienLuong,
        children: [
          if (wHangMuc[34].choPhep) TreeItem(data: MenuString.bangChamCong),
          if (wHangMuc[35].choPhep) TreeItem(data: MenuString.bangThanhToanLuong),
        ],
      ),

    ///TAI SAN
    if (wMaMC1Provider[7].choPhep)
      TreeItem(
        data: MenuString.taiSan,
        children: [
          if (wHangMuc[36].choPhep) TreeItem(data: MenuString.bangKhauHaoTSCD),
          if (wHangMuc[37].choPhep) TreeItem(data: MenuString.bangPhanBoCDCC),
        ],
      ),

    ///SO KE TOAN
    if (wMaMC1Provider[8].choPhep)
      TreeItem(
        data: MenuString.soKeToan,
        children: [
          if (wMaMC2Provider[3].choPhep)
            TreeItem(
              data: MenuString.nhatKy,
              children: [
                if (wHangMuc[38].choPhep) TreeItem(data: MenuString.soNhatKyChung),
                if (wHangMuc[39].choPhep) TreeItem(data: MenuString.soCaiTaiKhoan),
                if (wHangMuc[40].choPhep) TreeItem(data: MenuString.soChiTietTaiKhoan),
              ],
            ),
          if (wMaMC2Provider[4].choPhep)
            TreeItem(
              data: MenuString.baoCaoTaiChinh,
              children: [
                if (wHangMuc[42].choPhep) TreeItem(data: MenuString.bangCanDoiPhatSinh),
                if (wHangMuc[43].choPhep) TreeItem(data: MenuString.bangCanDoiKeToan),
                if (wHangMuc[44].choPhep) TreeItem(data: MenuString.baoCaoKQKD),
                if (wHangMuc[45].choPhep) TreeItem(data: MenuString.baoCaoLCTT),
                if (wHangMuc[46].choPhep) TreeItem(data: MenuString.thuyetMinhBCTC),
              ],
            ),
          if (wMaMC2Provider[5].choPhep)
            TreeItem(
              data: MenuString.baoCaoThue,
              children: [
                if (wHangMuc[41].choPhep) TreeItem(data: MenuString.thueTamTinh),
                if (wHangMuc[47].choPhep) TreeItem(data: MenuString.chuyenLo),
                if (wHangMuc[48].choPhep) TreeItem(data: MenuString.thueTNDN),
                if (wHangMuc[49].choPhep) TreeItem(data: MenuString.thueTNCN),
                if (wHangMuc[50].choPhep) TreeItem(data: MenuString.soThue),
              ],
            ),
        ],
      ),

    ///HE THONG
    if (wMaMC1Provider[9].choPhep)
      TreeItem(
        data: MenuString.heThong,
        children: [
          if (wHangMuc[0].choPhep) TreeItem(data: MenuString.thongTinDoanhNghiep),
          if (wHangMuc[1].choPhep) TreeItem(data: MenuString.danhSachNguoiDung),
          if (wHangMuc[2].choPhep) TreeItem(data: MenuString.phanQuyenNguoiDung),
          if (wHangMuc[3].choPhep) TreeItem(data: MenuString.tuyChon),
        ],
      ),
  ];
});

class MaDMModel {
  final String ma;
  final bool choPhep;

  const MaDMModel({required this.ma, this.choPhep = true});

  // Map<String, dynamic> toMap() {
  //   return {
  //     'ma': this.ma,
  //     'isShow': this.isShow,
  //   };
  // }

  factory MaDMModel.fromMap(Map<String, dynamic> map, {required String field}) {
    return MaDMModel(ma: map[field], choPhep: map['ChoPhep'] == 1 ? true : false);
  }
}
