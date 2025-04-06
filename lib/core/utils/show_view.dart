import 'package:app_ketoan/core/core.dart';
import 'package:app_ketoan/views/views.dart';
import 'package:app_ketoan/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../data/data.dart';

//DANH MỤC
void showHangHoa(BuildContext context) {
  showCustomDialog(context, title: MenuString.hangHoa, width: 1220, height: 600, child: HangHoaView(), onClose: () {});
}

void showThongTinHangHoa(BuildContext context, {HangHoaModel? hangHoa}){
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

//MUA BAN
void showMuaHang(BuildContext context) {
  showCustomDialog(context, title: MenuString.muaHang, width: 1100, height: 700, child: MuaHangView(), onClose: (){});
}
void showBanHang(BuildContext context) {
  showCustomDialog(context, title: MenuString.banHang, width: 1100, height: 700, child: BanHangView(), onClose: (){});
}

//THU CHI
void showPhieuThu(BuildContext context,{int? stt}) {
  showCustomDialog(context, title: MenuString.phieuThu, width: 550, height: 490, child: PhieuThuView(stt: stt,), onClose: () {});
}

void showPhieuChi(BuildContext context,{int? stt}) {
  showCustomDialog(context, title: MenuString.phieuChi, width: 550, height: 490, child: PhieuChiView(stt: stt,), onClose: () {});
}
void showBangKePhieuThu(BuildContext context) {
  showCustomDialog(context, title: MenuString.bangkePhieuThu, width: 1275, height: 600, child: BangKePhieuThuView(), onClose: () {});
}
void showBangKePhieuChi(BuildContext context) {
  showCustomDialog(context, title: MenuString.bangkePhieuChi, width: 1275, height: 600, child: BangKePhieuChiView(), onClose: () {});
}




