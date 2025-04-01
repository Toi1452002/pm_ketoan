import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../application.dart';

final maNghiepVuProvider = StateNotifierProvider.autoDispose<MaNghiepVuNotifier, List<MaNghiepVuModel>>((ref) {
  return MaNghiepVuNotifier();
});


final mnvLstThuProvider = FutureProvider.autoDispose<List<MaNghiepVuModel>>((ref) async {
  const sqlRepository = SqlRepository(tableName: TableName.maNghiepVu);
  final data = await sqlRepository.getData(where: "MaNV LIKE 'T%'");
  return data.map((e)=>MaNghiepVuModel.fromMap(e)).toList();
});//Lấy danh sách mã nghiệp vụ có chữ cái đầu là T (Thu)

final mnvLstChiProvider = FutureProvider.autoDispose<List<MaNghiepVuModel>>((ref) async {
  const sqlRepository = SqlRepository(tableName: TableName.maNghiepVu);
  final data = await sqlRepository.getData(where: "MaNV LIKE 'C%'");
  return data.map((e)=>MaNghiepVuModel.fromMap(e)).toList();
});//Lấy danh sách mã nghiệp vụ có chữ cái đầu là C(Chi)
