import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final bangKePhieuThuProvider = StateNotifierProvider.autoDispose<BangKePhieuThuNotifier, List<PhieuThuModel>>((ref) {
  return BangKePhieuThuNotifier();
});

final phieuThuProvider = StateNotifierProvider.autoDispose<PhieuThuNotifier, PhieuThuModel?>((ref) {
  return PhieuThuNotifier();
});


final phieuThuCTProvider = StateNotifierProvider<PhieuThuCTNotifier, List<PhieuThuChiTietModel>>((ref) {
  return PhieuThuCTNotifier();
});


final soTienGuiProvider = StateNotifierProvider.autoDispose<SoTienGuiNotifier, List<SoTienModel>>((ref) {
  return SoTienGuiNotifier();
});

