import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final phieuXuatProvider = StateNotifierProvider.autoDispose<PhieuXuatNotifier, PhieuXuatModel?>((ref) {
  return PhieuXuatNotifier();
});


final phieuXuatCTProvider = StateNotifierProvider<PhieuXuatCTNotifier, List<PhieuXuatCTModel>>((ref) {
  return PhieuXuatCTNotifier();
});


final bcPhieuXuatProvider = StateNotifierProvider.autoDispose<BCPhieuXuatNotifier, List<VBCPhieuXuatModel>>((ref) {
  return BCPhieuXuatNotifier();
});


