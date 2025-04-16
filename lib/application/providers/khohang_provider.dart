import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final bangKePhieuNhapProvider = StateNotifierProvider.autoDispose<BangKeHangNhapNotifier, List<BangKeHangNXModel>>((ref) {
  return BangKeHangNhapNotifier();
});
final bangKePhieuXuatProvider = StateNotifierProvider.autoDispose<BangKeHangXuatNotifier, List<BangKeHangNXModel>>((ref) {
  return BangKeHangXuatNotifier();
});