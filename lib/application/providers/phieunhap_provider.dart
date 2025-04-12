import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final phieuNhapProvider = StateNotifierProvider.autoDispose<PhieuNhapNotifier, PhieuNhapModel?>((ref) {
  return PhieuNhapNotifier();
});


final phieuNhapCTProvider = StateNotifierProvider<PhieuNhapCTNotifier, List<PhieuNhapCTModel>>((ref) {
  return PhieuNhapCTNotifier();
});

final bcPhieuNhapProvider = StateNotifierProvider.autoDispose<BCPhieuNhapNotifier, List<VBCPhieuNhapModel>>((ref) {
  return BCPhieuNhapNotifier();
});

