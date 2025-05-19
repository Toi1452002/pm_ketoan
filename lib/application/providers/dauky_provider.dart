import 'package:app_ketoan/application/notifier/dauky_notifier.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final dauKyHangHoaProvider = StateNotifierProvider.autoDispose<DauKyHangHoaNotifier, List<DauKyHangHoaModel>>((ref) {
  return DauKyHangHoaNotifier();
});

final dKyKhachHangProvider = StateNotifierProvider.autoDispose<DauKyKhachHangNotifier, List<DauKyKhachHangModel>>((ref) {
  return DauKyKhachHangNotifier();
});

final dkyTaiKhoanProvider = StateNotifierProvider.autoDispose<DkyTaiKhoanNotifier, List<DauKyTaiKhoangModel>>((ref) {
  return DkyTaiKhoanNotifier();
});


