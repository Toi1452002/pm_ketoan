import 'package:app_ketoan/application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';




final userInfoProvider = StateProvider<UserModel?>((ref)=>null);

final userProvider = StateNotifierProvider.autoDispose<UserNotifier, List<UserModel>>((ref) {
  return UserNotifier();
});
