import 'package:app_ketoan/application/application.dart';
import 'package:app_ketoan/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final tuyChonProvider = StateNotifierProvider<TuyChonNotifier,List<TuyChonModel>>((ref) {
  return TuyChonNotifier();
});
