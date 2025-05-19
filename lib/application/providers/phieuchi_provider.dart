import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:app_ketoan/data/models/sotien_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final bangKePhieuChiProvider = StateNotifierProvider.autoDispose<BangKePhieuChiNotifier, List<PhieuChiModel>>((ref) {
  return BangKePhieuChiNotifier();
});


final phieuChiProvider = StateNotifierProvider.autoDispose<PhieuchiNotifier, PhieuChiModel?>((ref) {
  return PhieuchiNotifier();
});

final phieuChiCTProvider = StateNotifierProvider<PhieuChiCTNotifier, List<PhieuChiCTModel>>((ref) {
  return PhieuChiCTNotifier();
});


final soTienMatProvider = StateNotifierProvider.autoDispose<SoTienMatNotifier, List<SoTienModel>>((ref) {
  return SoTienMatNotifier();
});
