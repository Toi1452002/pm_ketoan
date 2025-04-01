import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final bangKePhieuChiProvider = StateNotifierProvider.autoDispose<BangKePhieuChiNotifier, List<PhieuChiModel>>((ref) {
  return BangKePhieuChiNotifier();
});


final phieuChiProvider = StateNotifierProvider.autoDispose<PhieuchiNotifier, PhieuChiModel?>((ref) {
  return PhieuchiNotifier();
});