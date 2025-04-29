import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/views/views.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../data/data.dart';

//DANH MỤC
void showHangHoa(BuildContext context) {
  showCustomDialog(context, title: MenuString.hangHoa, width: 1220, height: 600, child: HangHoaView(), onClose: () {});
}

void showThongTinHangHoa(BuildContext context, {HangHoaModel? hangHoa}) {
  showCustomDialog(
    context,
    title: 'THÔNG TIN HÀNG HÓA',
    width: 600,
    height: 390,
    child: ThongTinHangHoaView(hangHoa: hangHoa),
    onClose: () {},
  );
}

void showKhachHang(BuildContext context) {
  showCustomDialog(
    context,
    title: MenuString.khachHang,
    width: 1210,
    height: 600,
    child: KhachHangView(),
    onClose: () {},
  );
}

void showNhanVien(BuildContext context) {
  showCustomDialog(
    context,
    title: MenuString.nhanVien,
    width: 1030,
    height: 600,
    child: NhanVienView(),
    onClose: () {},
  );
}

void showMaNghiepVu(BuildContext context) {
  showCustomDialog(
    context,
    title: MenuString.maNghiepVu,
    width: 360,
    height: 600,
    child: MaNghiepVuView(),
    onClose: () {},
  );
}

void showBangTaiKhoan(BuildContext context) {
  showCustomDialog(
    context,
    title: MenuString.bangTaiKhoan,
    width: 970,
    height: 700,
    child: BangTaiKhoanView(),
    onClose: () {},
  );
}

void showNoDauKy(BuildContext context) {
  showCustomDialog(context, title: MenuString.noDauKy, width: 700, height: 600, child: NoDauKyView(), onClose: () {});
}
void showTonDauKy(BuildContext context) {
  showCustomDialog(context, title: 'Đầu kỳ hàng hóa', width: 720, height: 600, child: TonDauKyView(), onClose: () {});
}

//HỆ THỐNG
void showThongTinDoanhNghiep(BuildContext context) {
  showCustomDialog(
    context,
    title: MenuString.thongTinDoanhNghiep,
    width: 1040,
    height: 700,
    child: ThongTinDoanhNghiepView(),
    onClose: () {},
  );
}

void showPQNG(BuildContext context) {
  showCustomDialog(
    context,
    title: MenuString.phanQuyenNguoiDung,
    width: 600,
    height: 600,
    child: PhanQuyenNguoiDungView(),
    onClose: () {},
  );
}

void showDSNguoiDung(BuildContext context) {
  showCustomDialog(
    context,
    title: MenuString.danhSachNguoiDung,
    width: 820,
    height: 600,
    child: UserView(),
    onClose: () {},
  );
}

void showTuyChon(BuildContext context) {
  showCustomDialog(context, title: MenuString.tuyChon, width: 500, height: 390, child: TuyChonView(), onClose: () {});
}

//MUA BAN
void showMuaHang(BuildContext context, {int? stt}) {
  showCustomDialog(
    context,
    title: 'NHẬP MUA HÀNG HÓA',
    width: 1100,
    height: 680,
    child: MuaHangView(stt: stt),
    onClose: () {},
  );
}

void showBaoCaoMuaHang(BuildContext context) {
  showCustomDialog(
    context,
    title: 'BẢNG KÊ HÓA ĐƠN HÀNG HÓA DICH VỤ MUA VÀO',
    width: 1210,
    height: 603,
    child: BaoCaoMuaHangView(),
    onClose: () {},
  );
}

void showBanHang(BuildContext context, {int? stt}) {
  showCustomDialog(
    context,
    title: 'XUẤT BÁN HÀNG HÓA',
    width: 1100,
    height: 680,
    child: BanHangView(stt: stt),
    onClose: () {},
  );
}

void showBaoCaoBanHang(BuildContext context) {
  showCustomDialog(
    context,
    title: 'BẢNG KÊ HÓA ĐƠN HÀNG HÓA DICH VỤ BÁN RA',
    width: 1210,
    height: 603,
    child: BaoCaoBanHangView(),
    onClose: () {},
  );
}

//THU CHI
void showPhieuThu(BuildContext context, {int? stt}) {
  showCustomDialog(
    context,
    title: MenuString.phieuThu,
    width: 550,
    height: 650,
    child: PhieuThuView(stt: stt),
    onClose: () {},
  );
}

void showPhieuChi(BuildContext context, {int? stt}) {
  showCustomDialog(
    context,
    title: MenuString.phieuChi,
    width: 550,
    height: 650,
    child: PhieuChiView(stt: stt),
    onClose: () {},
  );
}

void showBangKePhieuThu(BuildContext context) {
  showCustomDialog(
    context,
    title: MenuString.bangkePhieuThu,
    width: 1275,
    height: 600,
    child: BangKePhieuThuView(),
    onClose: () {},
  );
}

void showBangKePhieuChi(BuildContext context) {
  showCustomDialog(
    context,
    title: MenuString.bangkePhieuChi,
    width: 1275,
    height: 600,
    child: BangKePhieuChiView(),
    onClose: () {},
  );
}

void showViewPrinter(BuildContext context, Widget widget, {bool isPortrait = true}) {
  showCustomDialog(
    context,
    title: 'PRINT',
    width: isPortrait ? 600 : 900,
    height: 700,
    barrierDismissible: true,
    child: widget,
    onClose: () {},
  );
}

//KHO HANG
void showBangKeHangNhap(BuildContext context) {
  showCustomDialog(
    context,
    title: MenuString.bangKeHangNhap,
    width: 1050,
    height: 600,
    child: BangKeHangNhapView(),
    onClose: () {},
  );
}

void showBangKeHangXuat(BuildContext context) {
  showCustomDialog(
    context,
    title: MenuString.bangKeHangXuat,
    width: 1050,
    height: 600,
    child: BangKeHangXuatView(),
    onClose: () {},
  );
}
