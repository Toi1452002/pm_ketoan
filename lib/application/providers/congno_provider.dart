import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final congNoProvider = StateNotifierProvider.autoDispose<CongNoNotifier,List<SoMBHangModel> >((ref) {
  return CongNoNotifier();
});


final tongHopCongNoProvider = StateNotifierProvider.autoDispose<TongHopCongNoNotifier, List<Map<String,dynamic>>>((ref) {
  return TongHopCongNoNotifier();
});
